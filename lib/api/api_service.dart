import 'dart:convert';

import 'package:fixed_asset_frontend/api/data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api";
  final String wipEndPoint = "/wips/";
  final String wipItemEndPoint = "/wip-items/";
  final String fixedAssetEndPoint = "/fixed-assets/";

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
}
