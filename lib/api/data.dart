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

class Depreciation {
  final int id;
  final String depreciationDate;
  final String depreciationMethod;
  final String computation;
  final double bookValue;
  final int accountId;
  final String depreciationAccount;
  final String expenseAccount;
  final String journal;
  final double deprecicationAmount;
  final int fixedAssetId;
  final String fixedAssetCode;
  Depreciation({
    required this.id,
    required this.depreciationDate,
    required this.depreciationMethod,
    required this.computation,
    required this.bookValue,
    required this.accountId,
    required this.depreciationAccount,
    required this.expenseAccount,
    required this.journal,
    required this.deprecicationAmount,
    required this.fixedAssetId,
    required this.fixedAssetCode,
  });
  factory Depreciation.fromJson(Map<String, dynamic> json) {
    return Depreciation(
      id: json['depreciation_id'] ?? 0,
      depreciationDate: json['depreciation_date'] ?? '',
      depreciationMethod: json['method'] ?? '',
      computation: json['computation'] ?? '',
      bookValue: json['book_value'] ?? 0.0,
      accountId: json['account_id'] ?? 0,
      depreciationAccount: json['depreciation_account'] ?? '',
      expenseAccount: json['expense_account'] ?? '',

      journal: json['journal'] ?? '',
      deprecicationAmount: json['depreciation_amount'] ?? 0.0,
      fixedAssetId: json['fixed_asset_id'] ?? 0,
      fixedAssetCode: json['fixed_asset_code'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'depreciation_id': id,
      'depreciation_date': depreciationDate,
      'method': depreciationMethod,
      'computation': computation,
      'book_value': bookValue,
      'account_id': accountId,
      'depreciation_account': depreciationAccount,
      'expense_account': expenseAccount,
      'journal': journal,
      'depreciation_amount': deprecicationAmount,
      'fixed_asset_id': fixedAssetId,
      'fixed_asset_code': fixedAssetCode,
    };
  }
}

class DepreciationEvent {
  final int eventId;
  final DateTime depreciationDate;
  final double depreciationAmount;
  final double accumulatedDepreciationAmount;
  final double nbvDepreciaiton;
  final int policyId;
  final int assetId;
  final int depreciationId;
  DepreciationEvent({
    required this.eventId,
    required this.depreciationDate,
    required this.depreciationAmount,
    required this.accumulatedDepreciationAmount,
    required this.nbvDepreciaiton,
    required this.policyId,
    required this.assetId,
    required this.depreciationId,
  });
  factory DepreciationEvent.fromJson(Map<String, dynamic> json) {
    return DepreciationEvent(
      eventId: json['event_id'] ?? 0,
      depreciationDate: DateTime.parse(json['depreciation_date']),
      depreciationAmount: json['depreciation_amount'] ?? 0.0,
      accumulatedDepreciationAmount: json['accumulated_depreciation'] ?? 0.0,
      nbvDepreciaiton: json['nbv_depreciation'] ?? 0.0,
      policyId: json['policy'] ?? 0,
      assetId: json['asset'] ?? 0,
      depreciationId: json['depreciation'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'depreciation_date': DateFormat('yyyy-MM-dd').format(depreciationDate),
      'depreciation_amount': depreciationAmount,
      'accumulated_depreciation': accumulatedDepreciationAmount,
      'nbv_depreciation': nbvDepreciaiton,
      'policy': policyId,
      'asset': assetId,
      'depreciation': depreciationId,
    };
  }
}

class AssetPolicy {
  final int id;
  final int usefulLife;
  final String period;
  final DateTime startDate;
  final DateTime endDate;
  final String depreciationMethod;
  final double amount;
  final String status;
  final String remark;
  final int assetId;
  final String assetCode;
  final int companyId;
  final int departmentId;
  final int depreciationId;
  AssetPolicy({
    required this.id,
    required this.usefulLife,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.depreciationMethod,
    required this.amount,
    required this.status,
    required this.remark,
    required this.assetId,
    required this.assetCode,
    required this.companyId,
    required this.departmentId,
    required this.depreciationId,
  });
  factory AssetPolicy.fromJson(Map<String, dynamic> json) {
    return AssetPolicy(
      id: json['policy_id'] ?? 0,
      usefulLife: json['useful_life'] ?? 0,
      period: json['period'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? DateTime.now()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now()),
      depreciationMethod: json['method'] ?? '',
      amount: json['amount'] ?? 0.0,
      status: json['status'] ?? '',
      remark: json['remark'] ?? '',
      assetId: json['register'] ?? 0,
      assetCode: json['fixed_asset_code'] ?? '',
      companyId: json['company'] ?? 0,
      departmentId: json['department'] ?? 0,
      depreciationId: json['depreciation'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'policy_id': id,
      'useful_life': usefulLife,
      'period': period,
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
      'method': depreciationMethod,
      'amount': amount,
      'status': status,
      'remark': remark,
      'register': assetId,
      'fixed_asset_code': assetCode,
      'company': companyId,
      'department': departmentId,
      'depreciation': depreciationId,
    };
  }
}

class Department {
  final int id;
  final String code;
  final String name;

  Department({required this.id, required this.code, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['dept_id'],
      code: json['dept_code'],
      name: json['dept_name'],
    );
  }
}

class Role {
  final int id;
  final String name;
  final DateTime? createdAt;

  Role({required this.id, required this.name, this.createdAt});

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['role_id'],
      name: json['role_name'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now()),
    );
  }
}

class User {
  final int? id;
  final String name;
  final String email;
  final String? phoneNumber;
  final int departmentId;
  final int roleId;
  final String authProvider;

  User({
    this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.departmentId,
    required this.roleId,
    required this.authProvider,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "department": departmentId,
      "role": roleId,
      "auth_provider": authProvider,
    };
  }
}
// class LoginResponse {
//   final String message;
//   final String userName;
//   final String role;
//   final int userId;

//   LoginResponse({
//     required this.message,
//     required this.userName,
//     required this.role,
//     required this.userId,
//   });

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//    final userData = json['user'];
//   return LoginResponse(
//     message: json['message'],
//     userName: userData['name'],
//     role: userData['role'],
//     userId: userData['id'],
//     email: userData['email'] ?? '',
//     department: userData['department_name'] ?? '',
//     authProvider: userData['auth_provider'] ?? 'local',
//   );
//   }
// }
class LoginResponse {
  final String message;
  final String userName;
  final String role;
  final int userId;
  final String email;
  final String department;
  final String authProvider;

  LoginResponse({
    required this.message,
    required this.userName,
    required this.role,
    required this.userId,
    required this.email,
    required this.department,
    required this.authProvider,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final userData = json['user'];
    return LoginResponse(
      message: json['message'],
      userName: userData['name'] ?? '',
      role: userData['role'] ?? '',
      userId: userData['id'] ?? 0,
      email: userData['email'] ?? '',
      department: userData['department_name'] ?? '',
      authProvider: userData['auth_provider'] ?? 'local',
    );
  }
}

class Company {
  final int id;
  final String companyCode;
  final String companyName;
  final String branch;
  Company({
    required this.id,
    required this.companyCode,
    required this.companyName,
    required this.branch,
  });
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['company_id'] ?? 0,
      companyCode: json['company_code'] ?? '',
      companyName: json['company_name'] ?? '',
      branch: json['branch'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_code': companyCode,
      'company_name': companyName,
      'branch': branch,
    };
  }
}

//leases
class Leases {
  final int id;
  final String code;
  final String leaseType;
  final String description;
  final String leasorName;
  final double contractAmount;
  final double deposit;
  final double presentValue;
  final double downPayment;
  final double otherCost;
  final String currency;
  final String homeCurrency;
  final double exchangeRate;
  final double dismantlingCost;
  final DateTime contractDate;
  final DateTime startDate;
  final DateTime endDate;
  final int leaseTerm;
  final String leasePeriod;
  final double paymentAmount;
  final String paymentPeriod;
  final double discountRate;
  final String computation;
  final DateTime? changingDate;
  final double changingAmount;
  final String status;
  final String reason;

  Leases({
    required this.id,
    required this.code,
    required this.leaseType,
    required this.description,
    required this.leasorName,
    required this.contractAmount,
    required this.deposit,
    required this.presentValue,
    required this.downPayment,
    required this.otherCost,
    required this.currency,
    required this.homeCurrency,
    required this.exchangeRate,
    required this.dismantlingCost,
    required this.contractDate,
    required this.startDate,
    required this.endDate,
    required this.leaseTerm,
    required this.leasePeriod,
    required this.paymentAmount,
    required this.paymentPeriod,
    required this.discountRate,
    required this.computation,
    this.changingDate,
    required this.changingAmount,
    required this.status,
    required this.reason,
  });

  factory Leases.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      try {
        if (dateValue is String) {
          return DateTime.parse(dateValue);
        }
        return dateValue;
      } catch (e) {
        return DateTime.now();
      }
    }

    return Leases(
      id: json['id'] ?? 0,
      code: json['code']?.toString() ?? '',
      leaseType: json['lease_type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      leasorName: json['leasor_name']?.toString() ?? '',
      contractAmount: (json['contract_amount'] is num)
          ? (json['contract_amount'] as num).toDouble()
          : double.tryParse(json['contract_amount']?.toString() ?? '0') ?? 0.0,
      deposit: (json['deposit'] is num)
          ? (json['deposit'] as num).toDouble()
          : double.tryParse(json['deposit']?.toString() ?? '0') ?? 0.0,
      presentValue: (json['present_value'] is num)
          ? (json['present_value'] as num).toDouble()
          : double.tryParse(json['present_value']?.toString() ?? '0') ?? 0.0,
      downPayment: (json['down_payment'] is num)
          ? (json['down_payment'] as num).toDouble()
          : double.tryParse(json['down_payment']?.toString() ?? '0') ?? 0.0,
      otherCost: (json['other_cost'] is num)
          ? (json['other_cost'] as num).toDouble()
          : double.tryParse(json['other_cost']?.toString() ?? '0') ?? 0.0,
      currency: json['currency']?.toString() ?? 'MMK',
      homeCurrency: json['home_currency']?.toString() ?? 'MMK',
      exchangeRate: (json['exchange_rate'] is num)
          ? (json['exchange_rate'] as num).toDouble()
          : double.tryParse(json['exchange_rate']?.toString() ?? '0') ?? 0.0,
      dismantlingCost: (json['dismantling_cost'] is num)
          ? (json['dismantling_cost'] as num).toDouble()
          : double.tryParse(json['dismantling_cost']?.toString() ?? '0') ?? 0.0,
      contractDate: parseDate(json['contract_date']),
      startDate: parseDate(json['start_date']),
      endDate: parseDate(json['end_date']),
      leaseTerm: (json['lease_term'] is int)
          ? json['lease_term']
          : int.tryParse(json['lease_term']?.toString() ?? '0') ?? 0,
      leasePeriod: json['lease_period']?.toString() ?? '',
      paymentAmount: (json['payment_amount'] is num)
          ? (json['payment_amount'] as num).toDouble()
          : double.tryParse(json['payment_amount']?.toString() ?? '0') ?? 0.0,
      paymentPeriod: json['payment_period']?.toString() ?? '',
      discountRate: (json['discount_rate'] is num)
          ? (json['discount_rate'] as num).toDouble()
          : double.tryParse(json['discount_rate']?.toString() ?? '0') ?? 0.0,
      computation: json['computation']?.toString() ?? '',
      changingDate: json['changing_date'] != null
          ? parseDate(json['changing_date'])
          : null,
      changingAmount: (json['changing_amount'] is num)
          ? (json['changing_amount'] as num).toDouble()
          : double.tryParse(json['changing_amount']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'active',
      reason: json['reason']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'lease_type': leaseType,
      'description': description,
      'leasor_name': leasorName,
      'contract_amount': contractAmount,
      'deposit': deposit,
      'present_value': presentValue,
      'down_payment': downPayment,
      'other_cost': otherCost,
      'currency': currency,
      'home_currency': homeCurrency,
      'exchange_rate': exchangeRate,
      'dismantling_cost': dismantlingCost,
      'contract_date': DateFormat('yyyy-MM-dd').format(contractDate),
      'start_date': DateFormat('yyyy-MM-dd').format(startDate),
      'end_date': DateFormat('yyyy-MM-dd').format(endDate),
      'lease_term': leaseTerm,
      'lease_period': leasePeriod,
      'payment_amount': paymentAmount,
      'payment_period': paymentPeriod,
      'discount_rate': discountRate,
      'computation': computation,
      'changing_date': changingDate != null
          ? DateFormat('yyyy-MM-dd').format(changingDate!)
          : null,
      'changing_amount': changingAmount,
      'status': status,
      'reason': reason,
    };
  }
}
