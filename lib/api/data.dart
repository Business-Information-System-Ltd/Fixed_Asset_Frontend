import 'package:intl/intl.dart';

// class Wip {
//   final int id;
//   final String wipCode;
//   final String projectName;
//   final DateTime startDate;
//   final DateTime endDate;
//   final String description;
//   final String status;
//   final double totalAmount;
//   final String currency;
//   Wip({
//     required this.id,
//     required this.wipCode,
//     required this.projectName,
//     required this.startDate,
//     required this.endDate,
//     required this.description,
//     required this.status,
//     required this.totalAmount,
//     required this.currency,
//   });
//   factory Wip.fromJson(Map<String, dynamic> json) {
//     return Wip(
//       id: json['wip_id'] ?? '',
//       wipCode: json['wip_code'] ?? '',
//       projectName: json['project_name'] ?? '',
//       startDate: DateTime.parse(json['start_date'] ?? DateTime.now()),
//       endDate: DateTime.parse(json['end_date'] ?? DateTime.now()),
//       description: json['description'] ?? '',
//       status: json['status'] ?? 'progress',
//       totalAmount: json['total_amount'] ?? 0.0,
//       currency: json['currency'] ?? 'MMK',
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'wip_id': id,
//       'wip_code': wipCode,
//       'project_name': projectName,
//       'start_date': DateFormat('yyyy-MM-dd').format(startDate),
//       'end_date': DateFormat('yyyy-MM-dd').format(endDate),
//       'description': description,
//       'status': status,
//       'total_amount': totalAmount,
//       'currency': currency,
//     };
//   }
// }

// class WipItem {
//   final int id;
//   final String itemCode;
//   final String itemName;
//   final String costType;
//   final String description;
//   final int quantity;
//   final double unitCost;
//   final double totalCost;
//   final String currency;
//   final DateTime transactionDate;
//   final int wipId;
//   final String wipCode;
//   WipItem({
//     required this.id,
//     required this.itemCode,
//     required this.itemName,
//     required this.costType,
//     required this.description,
//     required this.quantity,
//     required this.unitCost,
//     required this.totalCost,
//     required this.currency,
//     required this.transactionDate,
//     required this.wipId,
//     required this.wipCode,
//   });
//   factory WipItem.fromJson(Map<String, dynamic> json) {
//     final wipId = json['wip_id'] ?? 0;
//     final wipCode = json['wip_code'] ?? '';
//     return WipItem(
//       id: json['item_id'] ?? '',
//       itemCode: json['item_code'] ?? '',
//       itemName: json['item_name'] ?? '',
//       costType: json['cost_type'] ?? '',
//       description: json['description'] ?? '',
//       quantity: json['quantity'] ?? 0,
//       unitCost: json['unit_cost'] ?? 0.0,
//       totalCost: json['total_cost'] ?? 0.0,
//       currency: json['currency'] ?? 'MMK',
//       transactionDate: DateTime.parse(
//         json['transaction_date'] ?? DateTime.now(),
//       ),
//       wipId: wipId,
//       wipCode: wipCode,
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'item_id': id,
//       'item_code': itemCode,
//       'item_name': itemName,
//       'cost_type': costType,
//       'description': description,
//       'quantity': quantity,
//       'unit_cost': unitCost,
//       'total_cost': totalCost,
//       'currency': currency,
//       'transaction_date': DateFormat('yyyy-MM-dd').format(transactionDate),
//       'wip_id': wipId,
//       'wip_code': wipCode,
//     };
//   }
// }

class Wip {
  final int id;
  final String wipCode;
  final String projectName;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String status;
  final double totalAmount;
  final String currency;

  Wip({
    required this.id,
    required this.wipCode,
    required this.projectName,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.status,
    required this.totalAmount,
    required this.currency,
  });
  Wip copyWith({
    int? id,
    String? wipCode,
    String? projectName,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    String? status,
    double? totalAmount,
    String? currency,
  }) {
    return Wip(
      id: id ?? this.id,
      wipCode: wipCode ?? this.wipCode,
      projectName: projectName ?? this.projectName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
    );
  }

  factory Wip.fromJson(Map<String, dynamic> json) {
    // Handle the id conversion properly
    int parseId(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        // Try to parse as int
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;

        // If it's a numeric string with extra characters
        final numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(numericString) ?? 0;
      }
      return 0;
    }

    // Handle date parsing safely
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      try {
        if (dateValue is String) {
          return DateTime.parse(dateValue.split('T')[0]); // Handle ISO format
        }
        return dateValue;
      } catch (e) {
        print('Error parsing date: $dateValue, error: $e');
        return DateTime.now();
      }
    }

    // Handle double parsing safely
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return Wip(
      id: parseId(json['wip_id']),
      wipCode: (json['wip_code']?.toString() ?? '').trim(),
      projectName: (json['project_name']?.toString() ?? '').trim(),
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      description: (json['description']?.toString() ?? '').trim(),
      status: (json['status']?.toString() ?? 'progress').trim(),
      totalAmount: parseDouble(json['total_amount']),
      currency: (json['currency']?.toString() ?? 'MMK').trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wip_id': id,
      'wip_code': wipCode,
      'project_name': projectName,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
      'description': description,
      'status': status,
      'total_amount': totalAmount,
      'currency': currency,
    };
  }
}

class WipItem {
  final int id;
  final String itemCode;
  final String itemName;
  final String costType; // Should be lowercase: 'cash' or 'bank'
  final String description;
  final double quantity; // Changed from int to double
  final double unitCost;
  final double totalCost;
  final String currency;
  final DateTime transactionDate;
  final int wipId;
  final String wipCode;

  WipItem({
    required this.id,
    required this.itemCode,
    required this.itemName,
    required this.costType,
    required this.description,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    required this.currency,
    required this.transactionDate,
    required this.wipId,
    required this.wipCode,
  });

  factory WipItem.fromJson(Map<String, dynamic> json) {
    // Helper functions for safe parsing
    int parseId(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
        final numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(numericString) ?? 0;
      }
      if (value is double) return value.toInt();
      return 0;
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      try {
        if (dateValue is String) {
          return DateTime.parse(dateValue.split('T')[0]);
        }
        return dateValue;
      } catch (e) {
        print('Error parsing date: $dateValue, error: $e');
        return DateTime.now();
      }
    }

    return WipItem(
      id: parseId(json['wip_item_id'] ?? json['item_id']),
      itemCode: (json['item_code']?.toString() ?? '').trim(),
      itemName: (json['item_name']?.toString() ?? '').trim(),
      costType: (json['cost_type']?.toString() ?? '').trim(),
      description: (json['description']?.toString() ?? '').trim(),
      quantity: parseDouble(json['quantity']),
      unitCost: parseDouble(json['unit_cost']),
      totalCost: parseDouble(json['total_cost']),
      currency: (json['currency']?.toString() ?? 'MMK').trim(),
      transactionDate: parseDate(json['transaction_date']),
      wipId: parseId(json['wip'] ?? json['wip_id']), // Django uses 'wip' field
      wipCode: (json['wip_code']?.toString() ?? '').trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'item_name': itemName,
      'cost_type': costType.toLowerCase(), // Must be lowercase for Django
      'description': description,
      'quantity': quantity,
      'unit_cost': unitCost,
      'total_cost': totalCost,
      'currency': currency,
      'transaction_date': DateFormat('yyyy-MM-dd').format(transactionDate),
      'wip': wipId, // Key fix: Django expects 'wip' not 'wip_id'
    };
  }
}

class FixedAssets {
  final int id;
  final String fixedAssetCode;
  final DateTime acquisitionDate;
  final String sourceType;
  final String assetStatus;
  final String assetName;
  final String assetModel;
  final String assetGroup;
  final String assetType;
  final String description;
  final int usefulLife;
  final String period;
  final DateTime capitalizationDate;
  final String homeCurrency;
  final String transactionCurrency;
  final double exchangeRate;
  final double acquisitionCost;
  final double homeAcquisitionCost;
  final double residualValue;
  final double transportationFee;
  final double tax;
  final double otherFee;
  final double totalAmount;
  final String computation;
  final double additionAmount;
  final String depreciationMethod;
  final double currentNbv;
  final String fixedAssetAccount;
  final String depreciationAccount;
  final String expenseAccount;
  final String supplier;
  final DateTime createdDate;
  FixedAssets({
    required this.id,
    required this.fixedAssetCode,
    required this.acquisitionDate,
    required this.sourceType,
    required this.assetStatus,
    required this.assetName,
    required this.assetModel,
    required this.assetGroup,
    required this.assetType,
    required this.description,
    required this.usefulLife,
    required this.period,
    required this.capitalizationDate,
    required this.homeCurrency,
    required this.transactionCurrency,
    required this.exchangeRate,
    required this.acquisitionCost,
    required this.homeAcquisitionCost,
    required this.residualValue,
    required this.transportationFee,
    required this.tax,
    required this.otherFee,
    required this.totalAmount,
    required this.computation,
    required this.additionAmount,
    required this.depreciationMethod,
    required this.currentNbv,
    required this.fixedAssetAccount,
    required this.depreciationAccount,
    required this.expenseAccount,
    required this.supplier,
    required this.createdDate,
  });
  factory FixedAssets.fromJson(Map<String, dynamic> json) {
    return FixedAssets(
      id: json['register_id'] ?? 0,
      fixedAssetCode: json['fixed_asset_code'] ?? '',
      acquisitionDate: DateTime.parse(
        json['acquisition_date'] ?? DateTime.now(),
      ),
      sourceType: json['source_type'] ?? '',
      assetStatus: json['asset_status'] ?? '',
      assetName: json['asset_name'] ?? '',
      assetModel: json['asset_model'] ?? '',
      assetGroup: json['asset_group'] ?? '',
      assetType: json['asset_type'] ?? '',
      description: json['description'] ?? '',
      usefulLife: json['useful_life'] ?? 0,
      period: json['period'] ?? '',
      capitalizationDate: DateTime.parse(
        json['capitalization_date'] ?? DateTime.now(),
      ),
      homeCurrency: json['home_currency'] ?? '',
      transactionCurrency: json['transaction_currency'] ?? '',
      exchangeRate: json['exchange_rate'] ?? 0.0,
      acquisitionCost: json['acquisition_cost'] ?? 0.0,
      homeAcquisitionCost: json['home_acquisition_cost'] ?? 0.0,
      residualValue: json['residual_value'] ?? 0.0,
      transportationFee: json['transportation_fee'] ?? 0.0,
      tax: json['tax'] ?? 0.0,
      otherFee: json['other_fee'] ?? 0.0,
      totalAmount: json['total_amount'] ?? 0.0,
      computation: json['computation'] ?? '',
      additionAmount: json['addition_amount'] ?? 0.0,
      depreciationMethod: json['depreciation_method'] ?? '',
      currentNbv: json['current_nbv'] ?? 0.0,
      fixedAssetAccount: json['fixed_asset_account'] ?? '',
      depreciationAccount: json['depreciation_account'] ?? '',
      expenseAccount: json['expense_account'] ?? '',
      supplier: json['supplier'] ?? '',
      createdDate: DateTime.parse(json['created_at'] ?? DateTime.now()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'register_id': id,
      'fixed_asset_code': fixedAssetCode,
      'acquisition_date': DateFormat('yyyy-MM-dd').format(acquisitionDate),
      'source_type': sourceType,
      'asset_status': assetStatus,
      'asset_name': assetName,
      'asset_model': assetModel,
      'asset_group': assetGroup,
      'asset_type': assetType,
      'description': description,
      'useful_life': usefulLife,
      'period': period,
      'capitalization_date': DateFormat(
        'yyyy-MM-dd',
      ).format(capitalizationDate),
      'home_currency': homeCurrency,
      'transaction_currency': transactionCurrency,
      'exchange_rate': exchangeRate,
      'acquisition_cost': acquisitionCost,
      'home_acquisition_cost': homeAcquisitionCost,
      'residual_value': residualValue,
      'transportation_fee': transportationFee,
      'tax': tax,
      'other_fee': otherFee,
      'total_amount': totalAmount,
      'computation': computation,
      'addition_amount': additionAmount,
      'depreciation_method': depreciationMethod,
      'current_nbv': currentNbv,
      'fixed_asset_account': fixedAssetAccount,
      'depreciation_account': depreciationAccount,
      'expense_account': expenseAccount,
      'supplier': supplier,
      'created_at': DateFormat('yyyy-MM-dd').format(createdDate),
    };
  }
}
