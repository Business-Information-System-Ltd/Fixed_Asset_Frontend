import 'dart:convert';

import 'package:fixed_asset_frontend/api/data.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api";
  final String wipEndPoint = "/wips/";
  final String wipItemEndPoint = "/wip-items/";
  final String fixedAssetEndPoint = "/fixed-assets/";

  //wip
  // Future<List<Wip>> fetchWipData() async {
  //   final response = await http.get(Uri.parse(baseUrl + wipEndPoint));
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     print("WIP Data: $data");
  //     return data.map((dynamic item) => Wip.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load WIP data');
  //   }
  // }

  // Future<void> postWipData(Wip newWip) async {
  //   final jsonData = newWip.toJson();
  //   print("Sending wip Json: $jsonData");
  //   final response = await http.post(
  //     Uri.parse(baseUrl + wipEndPoint),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode(jsonData),
  //   );
  //   print("API Wip Response Status: ${response.statusCode}");
  //   print("API Wip Response body: ${response.body}");
  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to post WIP data');
  //   }
  // }

  // //wip_item
  // Future<List<WipItem>> fetchWipItemData() async {
  //   final response = await http.get(Uri.parse(baseUrl + wipItemEndPoint));
  //   if (response.statusCode == 200) {
  //     List<dynamic> data = json.decode(response.body);
  //     print("WIP Item Data: $data");
  //     return data.map((dynamic item) => WipItem.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load WIP Item data');
  //   }
  // }

  // Future<void> postWipItemData(WipItem newWipItem) async {
  //   final jsonData = newWipItem.toJson();
  //   print("Sending wip item Json: $jsonData");
  //   final response = await http.post(
  //     Uri.parse(baseUrl + wipItemEndPoint),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: json.encode(jsonData),
  //   );
  //   print("API Wip Item Response Status: ${response.statusCode}");
  //   print("API Wip Item Response body: ${response.body}");
  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to post WIP Item data');
  //   }
  // }

  //wip
  Future<List<Wip>> fetchWipData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + wipEndPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("WIP Data received, count: ${data.length}");

        // Log first item to see structure
        if (data.isNotEmpty) {
          print("First WIP item structure: ${data[0]}");
        }

        return data.map((dynamic item) {
          try {
            return Wip.fromJson(item);
          } catch (e) {
            print('Error parsing WIP item: $item, error: $e');
            // Return a default Wip to prevent crashing
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

  //wip_item
  Future<List<WipItem>> fetchWipItemData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl + wipItemEndPoint));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        print("WIP Item Data received, count: ${data.length}");

        // Log first item to see structure
        if (data.isNotEmpty) {
          print("First WIP Item structure: ${data[0]}");
        }

        return data.map((dynamic item) {
          try {
            return WipItem.fromJson(item);
          } catch (e) {
            print('Error parsing WIP Item: $item, error: $e');
            // Return a default WipItem to prevent crashing
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
