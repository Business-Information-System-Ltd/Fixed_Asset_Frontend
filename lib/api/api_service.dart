import 'dart:convert';

import 'package:fixed_asset_frontend/api/data.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //  static const String baseUrl =
  //     "http://127.0.0.1:8000/api";
  static const String baseUrl =
      "https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api";
  final String wipEndPoint = "/wips/";
  final String wipItemEndPoint = "/wip-items/";
  final String fixedAssetEndPoint = "/fixed-assets/";
  final String depreciationEndPoint = "/depreciations/";
  final String depreciationEventEndPoint = "/depreciation-events/";
  final String assetPolicyEndPoint = "/asset-policies/";
  final String companyEndPoint = "/companies/";
  final String departmentEndPoint = "/departments/";
  final String roleEndPoint = "/roles/";
  final String signupEndPoint = "/signup/";
  final String loginEndPoint = "/login/";
  final String conventionEndpoint = "/convention-lists/";
  final String assetCategoryPolicyEndPoint = "/asset-category-policies/";
  final String categoryEndPoint = "/categories/";
  final String systemDefaultEndPoint = "/system-default/";
  final String assetBookEndPoint = "/asset-books/";
  final String bookLevelEndPoint = "/book-level-policies/";
  final String leaseLiabilityContractEndPoint = "/leases-contracts/";
  final String leaseLiabilityFinanceEndPoint = "/leases-financials/";
  final String currentUser = "/current-user/";

  // WIP methods
  Future<List<Wip>> fetchWipData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + wipEndPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("WIP Data received, count: ${data.length}");

        if (data.isNotEmpty) {
          print("First WIP item structure: ${data[0]}");
        }

        return data.map((dynamic item) {
          try {
            return Wip.fromJson(item);
          } catch (e) {
            print('Error parsing WIP item: $item, error: $e');
            return Wip(
              id: 0,
              wipCode: 'ERROR',
              projectName: 'Error parsing data',
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              description: '',
              status: 'error',
              totalAmount: 0.0,
              currency: 'MMK',
            );
          }
        }).toList();
      } else {
        print('Failed to load WIP data. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to load WIP data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in fetchWipData: $e');
      rethrow;
    }
  }

  Future<void> postWipData(Wip newWip) async {
    final jsonData = newWip.toJson();
    print("Sending wip Json: $jsonData");
    try {
      final response = await http.post(
        Uri.parse(baseUrl + wipEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(jsonData),
      );

      print("API Wip Response Status: ${response.statusCode}");
      print("API Wip Response body: ${response.body}");

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to post WIP data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in postWipData: $e');
      rethrow;
    }
  }

  // WIP Item methods
  Future<List<WipItem>> fetchWipItemData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + wipItemEndPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("WIP Item Data received, count: ${data.length}");

        if (data.isNotEmpty) {
          print("First WIP Item structure: ${data[0]}");
        }

        return data.map((dynamic item) {
          try {
            return WipItem.fromJson(item);
          } catch (e) {
            print('Error parsing WIP Item: $item, error: $e');
            return WipItem(
              id: 0,
              itemCode: 'ERROR',
              itemName: 'Error parsing data',
              costType: '',
              description: '',
              quantity: 0,
              unitCost: 0.0,
              totalCost: 0.0,
              currency: 'MMK',
              transactionDate: DateTime.now(),
              wipId: 0,
              wipCode: '',
            );
          }
        }).toList();
      } else {
        print('Failed to load WIP Item data. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to load WIP Item data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in fetchWipItemData: $e');
      rethrow;
    }
  }

  Future<void> postWipItemData(WipItem newWipItem) async {
    final jsonData = newWipItem.toJson();
    print("Sending wip item Json: $jsonData");

    try {
      final response = await http.post(
        Uri.parse(baseUrl + wipItemEndPoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(jsonData),
      );

      print("API Wip Item Response Status: ${response.statusCode}");
      print("API Wip Item Response body: ${response.body}");

      if (response.statusCode != 201) {
        throw Exception(
          'Failed to post WIP Item data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in postWipItemData: $e');
      rethrow;
    }
  }

  // NEW METHODS FOR AUTO-CALCULATION

  // Calculate total amount for a specific WIP project from its items
  Future<double> calculateWipTotalAmount(int wipId) async {
    try {
      // Fetch all WIP items
      final response = await http.get(Uri.parse(baseUrl + wipItemEndPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        double total = 0.0;

        // Filter items by wipId and sum totalCost
        for (var item in data) {
          try {
            final wipItem = WipItem.fromJson(item);
            if (wipItem.wipId == wipId) {
              total += wipItem.totalCost;
            }
          } catch (e) {
            print('Error parsing item in calculateWipTotalAmount: $e');
          }
        }

        print('✅ Calculated total for WIP $wipId: $total');
        return total;
      } else {
        print('Failed to calculate WIP total. Status: ${response.statusCode}');
        return 0.0;
      }
    } catch (e) {
      print('Exception in calculateWipTotalAmount: $e');
      return 0.0;
    }
  }

  // Update WIP total amount in the database
  Future<void> updateWipTotalAmount(int wipId, double totalAmount) async {
    try {
      // First, get the current WIP data
      final response = await http.get(Uri.parse('$baseUrl$wipEndPoint$wipId/'));

      if (response.statusCode == 200) {
        Map<String, dynamic> wipData = json.decode(response.body);

        // Update the total amount
        wipData['total_amount'] = totalAmount;

        // Send PUT request to update
        final updateResponse = await http.put(
          Uri.parse('$baseUrl$wipEndPoint$wipId/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(wipData),
        );

        if (updateResponse.statusCode == 200) {
          print(
            '✅ Successfully updated WIP total amount for project $wipId: $totalAmount',
          );
        } else {
          print(
            '❌ Failed to update WIP total amount. Status: ${updateResponse.statusCode}',
          );
        }
      } else {
        print(
          '❌ Failed to fetch WIP data for update. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in updateWipTotalAmount: $e');
    }
  }

  Future<Wip> getWipById(int wipId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$wipEndPoint$wipId/'));

      print('Fetching WIP by ID: $wipId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Wip.fromJson(data);
      } else {
        throw Exception(
          'Failed to get WIP by ID. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in getWipById: $e');
      rethrow;
    }
  }

  //update wip
  // Update WIP
  Future<void> updateWip(Wip wip) async {
    try {
      // First, check if WIP exists by trying to fetch it
      try {
        await getWipById(wip.id);
      } catch (e) {
        throw Exception('WIP with ID ${wip.id} does not exist');
      }

      // Send PUT request to update
      final response = await http.put(
        Uri.parse('$baseUrl$wipEndPoint${wip.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(wip.toJson()),
      );

      print('Update WIP Response Status: ${response.statusCode}');
      print('Update WIP Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to update WIP with ID ${wip.id}: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error updating wip ${wip.id}: $e');
      rethrow;
    }
  }

  // Fetch WIP items for a specific project
  Future<List<WipItem>> fetchWipItemsByProject(int wipId) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + wipItemEndPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Filter items by wipId
        return data
            .map((item) => WipItem.fromJson(item))
            .where((item) => item.wipId == wipId)
            .toList();
      } else {
        print(
          'Failed to fetch WIP items for project $wipId. Status: ${response.statusCode}',
        );
        return [];
      }
    } catch (e) {
      print('Exception in fetchWipItemsByProject: $e');
      return [];
    }
  }

  // Combined method: Calculate and update WIP total
  Future<void> calculateAndUpdateWipTotal(int wipId) async {
    try {
      final totalAmount = await calculateWipTotalAmount(wipId);
      await updateWipTotalAmount(wipId, totalAmount);
    } catch (e) {
      print('Exception in calculateAndUpdateWipTotal: $e');
    }
  }

  //Fixed_Asset
  Future<List<FixedAssets>> fetchFixedAssetData() async {
    final response = await http.get(Uri.parse(baseUrl + fixedAssetEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Fixed Asset Data: $data");
      return data.map((dynamic item) => FixedAssets.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Fixed Asset data');
    }
  }

  Future<void> postFixedAssetData(FixedAssets newFixedAsset) async {
    final jsonData = newFixedAsset.toJson();
    print("Sending fixed asset Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + fixedAssetEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Fixed Asset Response Status: ${response.statusCode}");
    print("API Fixed Asset Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Fixed Asset data');
    }
  }

  //depreciation
  Future<List<Depreciation>> fetchDepreciationData() async {
    final response = await http.get(Uri.parse(baseUrl + depreciationEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Deprecication Data: $data");
      return data.map((dynamic item) => Depreciation.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Depreciation data');
    }
  }

  Future<void> postDepreciationData(Depreciation newDepreciation) async {
    final jsonData = newDepreciation.toJson();
    print("Sending depreciation Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + depreciationEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Depreciation Response Status: ${response.statusCode}");
    print("API Depreciation Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Depreciation data');
    }
  }

  //depreciationEvent
  Future<List<DepreciationEvent>> fetchDepreciationEventData() async {
    final response = await http.get(
      Uri.parse(baseUrl + depreciationEventEndPoint),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Depreciation Event Data: $data");
      return data
          .map((dynamic item) => DepreciationEvent.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load Depreciation Event data');
    }
  }

  Future<void> postDepreciationEventData(
    DepreciationEvent newDepreciationEvent,
  ) async {
    final jsonData = newDepreciationEvent.toJson();
    print("Sending depreciation event Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + depreciationEventEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Depreciation Event Response Status: ${response.statusCode}");
    print("API Depreciation Event Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Depreciation Event data');
    }
  }

  //depreciation policy
  Future<List<AssetPolicy>> fetchAssetPolicyData() async {
    final response = await http.get(Uri.parse(baseUrl + assetPolicyEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Asset Policy Data: $data");
      return data.map((dynamic item) => AssetPolicy.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Asset Policy data');
    }
  }

  Future<void> postAssetPolicyData(AssetPolicy newAssetPolicy) async {
    final jsonData = newAssetPolicy.toJson();
    print("Sending asset policy Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + assetPolicyEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Asset Policy Response Status: ${response.statusCode}");
    print("API Asset Policy Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Asset Policy data');
    }
  }

  // Check depreciation status
  Future<Map<String, dynamic>> checkDepreciationStatus(int assetId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}fixed-assets/$assetId/depreciation_status/'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to check depreciation status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error checking depreciation status: $e');
    }
  }

  // Calculate depreciation
  Future<Map<String, dynamic>> calculateDepreciation(
    int assetId,
    bool postToJournal,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}depreciation/calculate/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'asset_id': assetId,
          'post_to_journal': postToJournal,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to calculate depreciation');
      }
    } catch (e) {
      throw Exception('Error calculating depreciation: $e');
    }
  }

  // Execute depreciation
  Future<Map<String, dynamic>> executeDepreciation({
    required int assetId,
    bool postToJournal = false,
    String journalDescription = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}fixed-assets/$assetId/depreciate/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'post_to_journal': postToJournal,
          'journal_description': journalDescription,
          'depreciation_date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to execute depreciation');
      }
    } catch (e) {
      throw Exception('Error executing depreciation: $e');
    }
  }

  // Get depreciation history
  Future<Map<String, dynamic>> getDepreciationHistory(int assetId) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}depreciation/calculate/?asset_id=$assetId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to get depreciation history: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting depreciation history: $e');
    }
  }

  Future<List<Department>> fetchDepartments() async {
    final response = await http.get(
      Uri.parse(baseUrl + departmentEndPoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Department.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load departments");
    }
  }

  Future<List<Role>> fetchRoles() async {
    final response = await http.get(
      Uri.parse(baseUrl + roleEndPoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Role.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load roles");
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(
      Uri.parse(baseUrl + signupEndPoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<bool> registerUser(User user, String password) async {
    final url = Uri.parse(baseUrl + signupEndPoint);

    final Map<String, dynamic> signupData = user.toJson();
    signupData['password_hash'] = password;

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(signupData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print("Signup Error: ${response.body}");
      return false;
    }
  }

  Future<LoginResponse?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + loginEndPoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print('Login response: $decodedData');
        final loginResponse = LoginResponse.fromJson(decodedData);
        if (loginResponse.token.isEmpty) {
          print('Warning: Token is empty!');
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', loginResponse.userId);
        await prefs.setString('userName', loginResponse.userName);
        await prefs.setString('role', loginResponse.role);

        return loginResponse;
      } else {
        return null;
      }
    } catch (e) {
      print("Login API Error: $e");
      return null;
    }
  }

  //convention List
  Future<List<Convention>> fetchConvention() async {
    final response = await http.get(
      Uri.parse(baseUrl + conventionEndpoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Convention.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load conveniton");
    }
  }

  Future<void> postConvention(Convention newConvention) async {
    final jsonData = newConvention.toJson();
    print("Sending convention Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + conventionEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Convention Response Status: ${response.statusCode}");
    print("API Convention Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Convention data');
    }
  }

  //getConventionById
  Future<Convention> getConventionById(int conventionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$conventionEndpoint$conventionId/'),
      );

      print('Fetching Convention by ID: $conventionId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Convention.fromJson(data);
      } else {
        throw Exception(
          'Failed to get Convention by ID. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in getConvenitonById: $e');
      rethrow;
    }
  }

  Future<List<Convention>> getConventions() async {
    final response = await http.get(
      Uri.parse(baseUrl + conventionEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Convention.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load conventions');
    }
  }

  //category
  Future<List<Category>> fetchAssetCategory() async {
    final response = await http.get(
      Uri.parse(baseUrl + categoryEndPoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load category");
    }
  }

  //asset category policy
  Future<List<AssetCategoryPolicy>> fetchAssetCategoryPolicy() async {
    final response = await http.get(
      Uri.parse(baseUrl + assetCategoryPolicyEndPoint),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => AssetCategoryPolicy.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load asset category policy");
    }
  }

  Future<void> postAssetCategoryPolicy(
    AssetCategoryPolicy newAssetCategoryPolicy,
  ) async {
    final jsonData = newAssetCategoryPolicy.toJson();
    print("Sending asset category policy Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + assetCategoryPolicyEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Asset Category Policy Response Status: ${response.statusCode}");
    print("API Asset Category Policy Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Asset Category Policy data');
    }
  }

  //get asset category policy by id
  Future<AssetCategoryPolicy> getAssetCategoryPolicyById(int policyId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$assetCategoryPolicyEndPoint$policyId/'),
      );

      print('Fetching Asset Category Policy by ID: $policyId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AssetCategoryPolicy.fromJson(data);
      } else {
        throw Exception(
          'Failed to get Asset Category Policy by ID. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in getAssetCategoryPolicyById: $e');
      rethrow;
    }
  }

  //update asset category policy
  Future<void> updateAssetCategoryPolicy(
    int policyId,
    AssetCategoryPolicy updatedPolicy,
  ) async {
    final jsonData = updatedPolicy.toJson();
    print("Updating asset category policy Json: $jsonData");

    final response = await http.put(
      Uri.parse('$baseUrl$assetCategoryPolicyEndPoint$policyId/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );

    print(
      "API Update Asset Category Policy Response Status: ${response.statusCode}",
    );
    print("API Update Asset Category Policy Response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception('Failed to update Asset Category Policy data');
    }
  }

  Future<List<SystemDefault>> fetchSystemDefault() async {
    final response = await http.get(Uri.parse(baseUrl + systemDefaultEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("System Default Data: $data");
      return data.map((dynamic item) => SystemDefault.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load System Default data');
    }
  }

  Future<void> postSystemDefault(SystemDefault newSystemDefault) async {
    final jsonData = newSystemDefault.toJson();
    print("Sending system default Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + systemDefaultEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API System Default Response Status: ${response.statusCode}");
    print("API System Default Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post System Default data');
    }
  }

  Future<void> updateSystemDefault(int id, SystemDefault systemDefault) async {
    final response = await http.put(
      Uri.parse('$baseUrl$systemDefaultEndPoint$id/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(systemDefault.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update System Default');
    }
  }

  Future<void> deleteSystemDefault(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$systemDefaultEndPoint$id/'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete System Default');
    }
  }

  //Asset Book
  Future<List<AssetBook>> fetchAssetBook() async {
    final response = await http.get(Uri.parse(baseUrl + assetBookEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Asset Book Data: $data");
      return data.map((dynamic item) => AssetBook.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load System Default data');
    }
  }

  Future<void> postAssetBook(AssetBook newAssetBook) async {
    final jsonData = newAssetBook.toJson();
    print("Sending Asset Book Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + assetBookEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Asset Book Response Status: ${response.statusCode}");
    print("API Asset Book Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Asset Book data');
    }
  }

  Future<void> updateAssetBook(int id, AssetBook assetBook) async {
    final response = await http.put(
      Uri.parse('$baseUrl$assetBookEndPoint$id/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(assetBook.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Asset Book');
    }
  }

  Future<void> deleteAssetBook(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$assetBookEndPoint$id/'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete System Default');
    }
  }

  //Book Level
  Future<List<BookPolicy>> fetchBookLevel() async {
    final response = await http.get(Uri.parse(baseUrl + bookLevelEndPoint));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print("Book Level Data: $data");
      return data.map((dynamic item) => BookPolicy.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Book policy data');
    }
  }

  Future<void> postBookLevel(BookPolicy newBookPolicy) async {
    final jsonData = newBookPolicy.toJson();
    print("Sending book level Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + bookLevelEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Book Level Response Status: ${response.statusCode}");
    print("API Book Level Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Book Level data');
    }
  }

  Future<void> updateBookLevel(int id, BookPolicy bookpolicy) async {
    final response = await http.put(
      Uri.parse('$baseUrl$bookLevelEndPoint$id/'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(bookpolicy.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update Book Level');
    }
  }

  Future<void> deleteBookLevel(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$bookLevelEndPoint$id/'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete Book Level');
    }
  }

  //lease financial List
  Future<List<Financial>> fetchLeaseFinancial() async {
    final response = await http.get(
      Uri.parse(baseUrl + leaseLiabilityFinanceEndPoint),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Financial> leaseFinancials = data
          .map((item) => Financial.fromJson(item))
          .toList();

      return leaseFinancials;
    } else {
      throw Exception('Failed to load Lease Financial data');
    }
  }

  //post lease financial
  Future<void> postLeaseFinancial(Financial newFinancial) async {
    final jsonData = newFinancial.toJson();
    print("Sending lease financial Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + leaseLiabilityFinanceEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Lease Financial Response Status: ${response.statusCode}");
    print("API Lease Financial Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Lease Financial data');
    }
  }

  //lease List
  Future<List<Lease>> fetchLease() async {
    final response = await http.get(
      Uri.parse(baseUrl + leaseLiabilityContractEndPoint),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<Lease> leases = data.map((item) => Lease.fromJson(item)).toList();

      return leases;
    } else {
      throw Exception('Failed to load Lease data');
    }
  }

  //post lease
  Future<void> postLease(Lease newLease) async {
    final jsonData = newLease.toJson();
    print("Sending lease Json: $jsonData");
    final response = await http.post(
      Uri.parse(baseUrl + leaseLiabilityContractEndPoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(jsonData),
    );
    print("API Lease Response Status: ${response.statusCode}");
    print("API Lease Response body: ${response.body}");
    if (response.statusCode != 201) {
      throw Exception('Failed to post Lease data');
    }
  }

  // GET LEASE BY ID
  Future<Lease> getLease(int id) async {
    final response = await http.get(
      Uri.parse(baseUrl + leaseLiabilityContractEndPoint + '$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Lease.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch lease');
    }
  }

  Future<Lease> updateLease(int id, Lease lease) async {
    final response = await http.put(
      Uri.parse(baseUrl + leaseLiabilityContractEndPoint + '$id/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(lease.toJson()),
    );
    if (response.statusCode == 200) {
      return Lease.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update lease');
    }
  }
}
