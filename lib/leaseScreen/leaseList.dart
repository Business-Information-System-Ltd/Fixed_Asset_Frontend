// // import 'package:fixed_asset_frontend/api/api_service.dart';
// import 'package:fixed_asset_frontend/screens/date_filter.dart';
// import 'package:fixed_asset_frontend/screens/pagination.dart';
// import 'package:fixed_asset_frontend/screens/search_function.dart';
// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:intl/intl.dart';

// class Leases {
//   final int id;
//   final String code;
//   final String leaseType;
//   final String description;
//   final String leasorName;
//   final double contractAmount;
//   final double deposit;
//   final double presentValue;
//   final double downPayment;
//   final double otherCost;
//   final String currency;
//   final String homeCurrency;
//   final double exchangeRate;
//   final double dismantlingCost;
//   final DateTime contractDate;
//   final DateTime startDate;
//   final DateTime endDate;
//   final int leaseTerm;
//   final String leasePeriod;
//   final double paymentAmount;
//   final String paymentPeriod;
//   final double discountRate;
//   final String computation;
//   final DateTime? changingDate;
//   final double changingAmount;
//   final String status;
//   final String reason;

//   Leases({
//     required this.id,
//     required this.code,
//     required this.leaseType,
//     required this.description,
//     required this.leasorName,
//     required this.contractAmount,
//     required this.deposit,
//     required this.presentValue,
//     required this.downPayment,
//     required this.otherCost,
//     required this.currency,
//     required this.homeCurrency,
//     required this.exchangeRate,
//     required this.dismantlingCost,
//     required this.contractDate,
//     required this.startDate,
//     required this.endDate,
//     required this.leaseTerm,
//     required this.leasePeriod,
//     required this.paymentAmount,
//     required this.paymentPeriod,
//     required this.discountRate,
//     required this.computation,
//     this.changingDate,
//     required this.changingAmount,
//     required this.status,
//     required this.reason,
//   });

//   factory Leases.fromJson(Map<String, dynamic> json) {
//     DateTime parseDate(dynamic dateValue) {
//       if (dateValue == null) return DateTime.now();
//       try {
//         if (dateValue is String) {
//           return DateTime.parse(dateValue);
//         }
//         return dateValue;
//       } catch (e) {
//         return DateTime.now();
//       }
//     }

//     return Leases(
//       id: json['id'] ?? 0,
//       code: json['code']?.toString() ?? '',
//       leaseType: json['lease_type']?.toString() ?? '',
//       description: json['description']?.toString() ?? '',
//       leasorName: json['leasor_name']?.toString() ?? '',
//       contractAmount: (json['contract_amount'] is num)
//           ? (json['contract_amount'] as num).toDouble()
//           : double.tryParse(json['contract_amount']?.toString() ?? '0') ?? 0.0,
//       deposit: (json['deposit'] is num)
//           ? (json['deposit'] as num).toDouble()
//           : double.tryParse(json['deposit']?.toString() ?? '0') ?? 0.0,
//       presentValue: (json['present_value'] is num)
//           ? (json['present_value'] as num).toDouble()
//           : double.tryParse(json['present_value']?.toString() ?? '0') ?? 0.0,
//       downPayment: (json['down_payment'] is num)
//           ? (json['down_payment'] as num).toDouble()
//           : double.tryParse(json['down_payment']?.toString() ?? '0') ?? 0.0,
//       otherCost: (json['other_cost'] is num)
//           ? (json['other_cost'] as num).toDouble()
//           : double.tryParse(json['other_cost']?.toString() ?? '0') ?? 0.0,
//       currency: json['currency']?.toString() ?? 'MMK',
//       homeCurrency: json['home_currency']?.toString() ?? 'MMK',
//       exchangeRate: (json['exchange_rate'] is num)
//           ? (json['exchange_rate'] as num).toDouble()
//           : double.tryParse(json['exchange_rate']?.toString() ?? '0') ?? 0.0,
//       dismantlingCost: (json['dismantling_cost'] is num)
//           ? (json['dismantling_cost'] as num).toDouble()
//           : double.tryParse(json['dismantling_cost']?.toString() ?? '0') ?? 0.0,
//       contractDate: parseDate(json['contract_date']),
//       startDate: parseDate(json['start_date']),
//       endDate: parseDate(json['end_date']),
//       leaseTerm: (json['lease_term'] is int)
//           ? json['lease_term']
//           : int.tryParse(json['lease_term']?.toString() ?? '0') ?? 0,
//       leasePeriod: json['lease_period']?.toString() ?? '',
//       paymentAmount: (json['payment_amount'] is num)
//           ? (json['payment_amount'] as num).toDouble()
//           : double.tryParse(json['payment_amount']?.toString() ?? '0') ?? 0.0,
//       paymentPeriod: json['payment_period']?.toString() ?? '',
//       discountRate: (json['discount_rate'] is num)
//           ? (json['discount_rate'] as num).toDouble()
//           : double.tryParse(json['discount_rate']?.toString() ?? '0') ?? 0.0,
//       computation: json['computation']?.toString() ?? '',
//       changingDate: json['changing_date'] != null
//           ? parseDate(json['changing_date'])
//           : null,
//       changingAmount: (json['changing_amount'] is num)
//           ? (json['changing_amount'] as num).toDouble()
//           : double.tryParse(json['changing_amount']?.toString() ?? '0') ?? 0.0,
//       status: json['status']?.toString() ?? 'active',
//       reason: json['reason']?.toString() ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'code': code,
//       'lease_type': leaseType,
//       'description': description,
//       'leasor_name': leasorName,
//       'contract_amount': contractAmount,
//       'deposit': deposit,
//       'present_value': presentValue,
//       'down_payment': downPayment,
//       'other_cost': otherCost,
//       'currency': currency,
//       'home_currency': homeCurrency,
//       'exchange_rate': exchangeRate,
//       'dismantling_cost': dismantlingCost,
//       'contract_date': DateFormat('yyyy-MM-dd').format(contractDate),
//       'start_date': DateFormat('yyyy-MM-dd').format(startDate),
//       'end_date': DateFormat('yyyy-MM-dd').format(endDate),
//       'lease_term': leaseTerm,
//       'lease_period': leasePeriod,
//       'payment_amount': paymentAmount,
//       'payment_period': paymentPeriod,
//       'discount_rate': discountRate,
//       'computation': computation,
//       'changing_date': changingDate != null
//           ? DateFormat('yyyy-MM-dd').format(changingDate!)
//           : null,
//       'changing_amount': changingAmount,
//       'status': status,
//       'reason': reason,
//     };
//   }
// }

// class Leaselist extends StatefulWidget {
//   const Leaselist({super.key});

//   @override
//   State<Leaselist> createState() => _LeaselistState();
// }

// class _LeaselistState extends State<Leaselist> {
//   PlutoGridStateManager? _stateManager;
//   int? selectedLeaseId;
//   bool showLeaseDetails = false;
//   List<PlutoColumn> _columns = [];
//   List<PlutoRow> _rows = [];
//   List<PlutoRow> _pagedRows = [];
//   List<Leases> leasesData = [];
//   List<Leases> _filteredLeases = [];
//   DateTimeRange? _currentDateRange;
//   String? _currentFilterType;
//   String _searchQuery = '';
//   int _currentPage = 1;
//   int _rowsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//     _columns = _buildColumns();
//   }

//   void _initializeData() {
//     // Using hardcoded data since no database yet
//     final List<Map<String, dynamic>> leaseData = [
//       {
//         'id': 1,
//         'code': 'L-001',
//         'lease_type': 'Land',
//         'description': 'South Dagon Land',
//         'leasor_name': 'Su Su',
//         'contract_amount': 2000000.0,
//         'deposit': 700000.0,
//         'present_value': 40000000.0,
//         'down_payment': 300000.0,
//         'other_cost': 600000.0,
//         'currency': 'MMK',
//         'home_currency': 'MMK',
//         'exchange_rate': 0.0,
//         'dismantling_cost': 500000.0,
//         'contract_date': '2026-04-11',
//         'start_date': '2026-04-12',
//         'end_date': '2031-04-12',
//         'lease_term': 5,
//         'lease_period': 'year',
//         'payment_amount': 2000000.0,
//         'payment_period': 'per year',
//         'discount_rate': 0.0,
//         'computation': 'year',
//         'changing_date': '2028-04-11',
//         'changing_amount': 4000000.0,
//         'status': 'Active',
//         'reason': 'progress lease',
//       },
//       {
//         'id': 2,
//         'code': 'L-002',
//         'lease_type': 'Building',
//         'description': 'Office Building',
//         'leasor_name': 'Mg Mg',
//         'contract_amount': 5000000.0,
//         'deposit': 1500000.0,
//         'present_value': 80000000.0,
//         'down_payment': 1000000.0,
//         'other_cost': 800000.0,
//         'currency': 'USD',
//         'home_currency': 'MMK',
//         'exchange_rate': 2100.0,
//         'dismantling_cost': 700000.0,
//         'contract_date': '2026-03-15',
//         'start_date': '2026-04-01',
//         'end_date': '2031-03-31',
//         'lease_term': 5,
//         'lease_period': 'year',
//         'payment_amount': 1000000.0,
//         'payment_period': 'per year',
//         'discount_rate': 5.0,
//         'computation': 'year',
//         'changing_date': null,
//         'changing_amount': 0.0,
//         'status': 'Amendment',
//         'reason': 'Amount Changed',
//       },
//       {
//         'id': 3,
//         'code': 'L-003',
//         'lease_type': 'Equipment',
//         'description': 'Construction Equipment',
//         'leasor_name': 'Ko Ko',
//         'contract_amount': 3000000.0,
//         'deposit': 900000.0,
//         'present_value': 25000000.0,
//         'down_payment': 600000.0,
//         'other_cost': 400000.0,
//         'currency': 'MMK',
//         'home_currency': 'MMK',
//         'exchange_rate': 0.0,
//         'dismantling_cost': 300000.0,
//         'contract_date': '2026-02-20',
//         'start_date': '2026-03-01',
//         'end_date': '2029-02-28',
//         'lease_term': 3,
//         'lease_period': 'year',
//         'payment_amount': 1000000.0,
//         'payment_period': 'per year',
//         'discount_rate': 7.0,
//         'computation': 'year',
//         'changing_date': '2027-02-20',
//         'changing_amount': 3500000.0,
//         'status': 'Completed',
//         'reason': 'construction project',
//       },
//       {
//         'id': 4,
//         'code': 'L-004',
//         'lease_type': 'Vehicle',
//         'description': 'Delivery Truck',
//         'leasor_name': 'Aung Aung',
//         'contract_amount': 1500000.0,
//         'deposit': 450000.0,
//         'present_value': 12000000.0,
//         'down_payment': 300000.0,
//         'other_cost': 200000.0,
//         'currency': 'MMK',
//         'home_currency': 'MMK',
//         'exchange_rate': 0.0,
//         'dismantling_cost': 150000.0,
//         'contract_date': '2026-01-10',
//         'start_date': '2026-01-15',
//         'end_date': '2028-01-14',
//         'lease_term': 2,
//         'lease_period': 'year',
//         'payment_amount': 750000.0,
//         'payment_period': 'per year',
//         'discount_rate': 6.5,
//         'computation': 'year',
//         'changing_date': null,
//         'changing_amount': 0.0,
//         'status': 'Active',
//         'reason': 'delivery service',
//       },
//       {
//         'id': 5,
//         'code': 'L-005',
//         'lease_type': 'Land',
//         'description': 'Industrial Plot',
//         'leasor_name': 'Hla Hla',
//         'contract_amount': 8000000.0,
//         'deposit': 2400000.0,
//         'present_value': 60000000.0,
//         'down_payment': 1600000.0,
//         'other_cost': 1200000.0,
//         'currency': 'USD',
//         'home_currency': 'MMK',
//         'exchange_rate': 2100.0,
//         'dismantling_cost': 1000000.0,
//         'contract_date': '2025-12-01',
//         'start_date': '2026-01-01',
//         'end_date': '2036-12-31',
//         'lease_term': 10,
//         'lease_period': 'year',
//         'payment_amount': 800000.0,
//         'payment_period': 'per year',
//         'discount_rate': 8.0,
//         'computation': 'year',
//         'changing_date': '2031-12-01',
//         'changing_amount': 10000000.0,
//         'status': 'Cancelled',
//         'reason': 'terminated early',
//       },
//     ];

//     setState(() {
//       leasesData = leaseData.map((data) => Leases.fromJson(data)).toList();
//       _filteredLeases = leasesData;
//       _rows = _buildRows(_filteredLeases);
//       _updatePagedRows();
//     });
//   }

//   void _applyFilter() {
//     List<Leases> filtered = leasesData;

//     // Apply date filter
//     if (_currentDateRange != null) {
//       final startDate = DateTime(
//         _currentDateRange!.start.year,
//         _currentDateRange!.start.month,
//         _currentDateRange!.start.day,
//       );
//       final endDate = DateTime(
//         _currentDateRange!.end.year,
//         _currentDateRange!.end.month,
//         _currentDateRange!.end.day,
//       ).add(const Duration(days: 1));

//       filtered = filtered.where((lease) {
//         final leaseDate = DateTime(
//           lease.startDate.year,
//           lease.startDate.month,
//           lease.startDate.day,
//         );
//         return leaseDate.isAtSameMomentAs(startDate) ||
//             (leaseDate.isAfter(startDate) && leaseDate.isBefore(endDate));
//       }).toList();
//     }

//     // Apply search filter
//     if (_searchQuery.isNotEmpty) {
//       final query = _searchQuery.toLowerCase();
//       filtered = filtered.where((lease) {
//         return lease.code.toLowerCase().contains(query) ||
//             lease.leaseType.toLowerCase().contains(query) ||
//             lease.description.toLowerCase().contains(query) ||
//             lease.leasorName.toLowerCase().contains(query) ||
//             lease.status.toLowerCase().contains(query);
//       }).toList();
//     }

//     setState(() {
//       _filteredLeases = filtered;
//       _rows = _buildRows(_filteredLeases);
//       _currentPage = 1;
//       _updatePagedRows();
//     });
//   }

//   void _updatePagedRows() {
//     final start = (_currentPage - 1) * _rowsPerPage;
//     final end = (_currentPage * _rowsPerPage).clamp(0, _rows.length);
//     setState(() {
//       _pagedRows = _rows.sublist(start, end);
//     });

//     if (_stateManager != null) {
//       _stateManager!.removeAllRows();
//       _stateManager!.appendRows(_pagedRows);
//     }
//   }

//   void _handleDateRangeChange(DateTimeRange range, String selectedValue) {
//     setState(() {
//       _currentDateRange = range;
//       _currentFilterType = selectedValue;
//     });
//     _applyFilter();
//   }

//   void _handleSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//     _applyFilter();
//   }

//   List<PlutoColumn> _buildColumns([double screenWidth = 1024]) {
//     final isSmallScreen = screenWidth < 768;
//     final isMediumScreen = screenWidth < 1024;

//     return [
//       PlutoColumn(
//         title: 'Code',
//         field: 'code',
//         readOnly: true,
//         enableEditingMode: false,
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 80 : 100,
//       ),
//       PlutoColumn(
//         title: 'Lease Type',
//         field: 'lease_type',
//         readOnly: true,
//         enableEditingMode: false,
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 100 : 120,
//       ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'Description',
//           field: 'description',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.text(),
//           width: isSmallScreen ? 180 : 200,
//         ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'Leasor Name',
//           field: 'leasor_name',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.text(),
//           width: isSmallScreen ? 100 : 150,
//         ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'Contract Date',
//           field: 'contract_date',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.text(),
//           width: isSmallScreen ? 100 : 150,
//         ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'Start Date',
//           field: 'start_date',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.date(),
//           width: isSmallScreen ? 90 : 110,
//         ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'End Date',
//           field: 'end_date',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.date(),
//           width: isSmallScreen ? 90 : 110,
//         ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'Lease Term',
//           field: 'lease_term',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.text(),
//           width: isSmallScreen ? 80 : 100,
//         ),
//       if (!isSmallScreen)
//         PlutoColumn(
//           title: 'Lease Period',
//           field: 'lease_period',
//           readOnly: true,
//           enableEditingMode: false,
//           type: PlutoColumnType.text(),
//           width: isSmallScreen ? 80 : 100,
//         ),
//       PlutoColumn(
//         title: 'Contract Amount',
//         field: 'contract_amount',
//         readOnly: true,
//         enableEditingMode: false,
//         type: PlutoColumnType.number(),
//         width: isSmallScreen ? 120 : 150,
//         textAlign: PlutoColumnTextAlign.right,
//         titleTextAlign: PlutoColumnTextAlign.right,
//         renderer: (rendererContext) {
//           final row = rendererContext.row;
//           final amount = row.cells['contract_amount']!.value;
//           final currency = row.cells['currency']!.value;
//           return Text(
//             '$currency ${amount.toStringAsFixed(2)}',
//             textAlign: TextAlign.end,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.blue,
//               fontSize: isSmallScreen ? 12 : 14,
//             ),
//           );
//         },
//       ),

//       PlutoColumn(
//         title: 'Status',
//         field: 'status',
//         readOnly: true,
//         enableEditingMode: false,
//         type: PlutoColumnType.select(<String>[
//           'active',
//           'completed',
//           'amendment',
//           'cancelled',
//         ]),
//         width: isSmallScreen ? 100 : 120,
//         renderer: (rendererContext) {
//           final status = rendererContext.cell.value;
//           Color color;
//           switch (status.toLowerCase()) {
//             case 'active':
//               color = Colors.green;
//             case 'completed':
//               color = Colors.blue;
//             case 'amendment':
//               color = Colors.orange;
//             case 'cancelled':
//               color = Colors.red;
//             default:
//               color = Colors.grey;
//           }
//           return Center(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               child: Text(
//                 status,
//                 style: TextStyle(
//                   color: color,
//                   fontWeight: FontWeight.w500,
//                   fontSize: isSmallScreen ? 12 : 14,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//       PlutoColumn(
//         title: 'Actions',
//         field: 'actions',
//         enableEditingMode: false,
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 80 : 100,
//         renderer: (rendererContext) {
//           final row = rendererContext.row;
//           final leaseCode = row.cells['code']!.value as String;
//           final lease = leasesData.firstWhere((l) => l.code == leaseCode);

//           return Center(
//             child: IconButton(
//               icon: const Icon(Icons.visibility, size: 18),
//               onPressed: () {
//                 _showLeaseDetails(lease.id);
//               },
//               tooltip: 'View Details',
//               color: Colors.blue,
//             ),
//           );
//         },
//       ),
//       // Hidden columns
//       PlutoColumn(
//         title: 'id',
//         field: 'id',
//         type: PlutoColumnType.number(),
//         width: 0,
//         hide: true,
//       ),
//       PlutoColumn(
//         title: 'currency',
//         field: 'currency',
//         type: PlutoColumnType.text(),
//         width: 0,
//         hide: true,
//       ),
//     ];
//   }

//   List<PlutoRow> _buildRows(List<Leases> leases) {
//     return leases.map((lease) {
//       return PlutoRow(
//         key: ValueKey(lease.id),
//         cells: {
//           'code': PlutoCell(value: lease.code),
//           'lease_type': PlutoCell(value: lease.leaseType),
//           'description': PlutoCell(value: lease.description),
//           'leasor_name': PlutoCell(value: lease.leasorName),
//           'contract_date': PlutoCell(
//             value: DateFormat('yyyy-MM-dd').format(lease.contractDate),
//           ),
//           'start_date': PlutoCell(
//             value: DateFormat('yyyy-MM-dd').format(lease.startDate),
//           ),
//           'end_date': PlutoCell(
//             value: DateFormat('yyyy-MM-dd').format(lease.endDate),
//           ),
//           'lease_term': PlutoCell(
//             value: '${lease.leaseTerm} ${lease.leasePeriod}',
//           ),
//           'lease_period': PlutoCell(value: lease.leasePeriod),
//           'contract_amount': PlutoCell(value: lease.contractAmount),
//           'status': PlutoCell(value: lease.status),
//           'actions': PlutoCell(value: ''),
//           'id': PlutoCell(value: lease.id),
//           'currency': PlutoCell(value: lease.currency),
//         },
//       );
//     }).toList();
//   }

//   void _showLeaseDetails(int leaseId) {
//     setState(() {
//       selectedLeaseId = leaseId;
//       showLeaseDetails = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 1024;

//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Lease Register Lists',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             // Add new lease button
//             if (!showLeaseDetails)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Container(
//                   height: 45,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       ElevatedButton.icon(
//                         icon: const Icon(
//                           Icons.add,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                         label: const Text(
//                           'Add New Lease',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         onPressed: () {
//                           // Navigate to lease form
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[800],
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 30,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4.0),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//             // Filter and Search Bar
//             if (!showLeaseDetails)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 child: Row(
//                   children: [
//                     Flexible(
//                       child: DateFilterDropdown(
//                         onDateRangeChanged: _handleDateRangeChange,
//                         selectedValue: _currentFilterType,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     if (_currentFilterType != null)
//                       Chip(
//                         label: Text(
//                           'Filter: ${_currentFilterType!.replaceAll('_', ' ')}',
//                         ),
//                         onDeleted: () {
//                           setState(() {
//                             _currentDateRange = null;
//                             _currentFilterType = null;
//                           });
//                           _applyFilter();
//                         },
//                       ),
//                     const SizedBox(width: 20),
//                     Expanded(
//                       flex: 2,
//                       child: CustomSearchBar(
//                         onSearch: _handleSearch,
//                         hintText: 'Search by Lease Code, Type, Description...',
//                         minWidth: 300,
//                         maxWidth: 600,
//                         initialValue: _searchQuery,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             // Stats Summary Cards
//             if (!showLeaseDetails) _buildStatsSummary(),
//             const SizedBox(height: 16),

//             // Main Content
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Lease List Table
//                   if (!showLeaseDetails)
//                     Expanded(flex: 2, child: _buildLeaseTable(isSmallScreen)),

//                   // Lease Details Panel
//                   if (showLeaseDetails && selectedLeaseId != null)
//                     Expanded(flex: 1, child: _buildLeaseDetails()),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsSummary() {
//     final totalLeases = _filteredLeases.length;
//     final activeLeases = _filteredLeases
//         .where((l) => l.status.toLowerCase() == 'active')
//         .length;
//     final completedLeases = _filteredLeases
//         .where((l) => l.status.toLowerCase() == 'completed')
//         .length;
//     final totalContractValue = _filteredLeases.fold(
//       0.0,
//       (sum, lease) => sum + lease.contractAmount,
//     );
//     final avgContractValue = totalLeases > 0
//         ? totalContractValue / totalLeases
//         : 0.0;

//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total Leases',
//             totalLeases.toString(),
//             Icons.assignment,
//             Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Active Leases',
//             activeLeases.toString(),
//             Icons.check_circle,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Completed',
//             completedLeases.toString(),
//             Icons.done_all,
//             Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Avg Contract',
//             '${_getCurrencySymbol(_filteredLeases.isNotEmpty ? _filteredLeases.first.currency : 'MMK')} ${avgContractValue.toStringAsFixed(0)}',
//             Icons.attach_money,
//             Colors.orange,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(7),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(24),
//               ),
//               child: Icon(icon, size: 24, color: color),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLeaseTable(bool isSmallScreen) {
//     return Column(
//       children: [
//         Expanded(
//           child: Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(8),
//               child: PlutoGrid(
//                 columns: _columns,
//                 rows: _pagedRows,
//                 onLoaded: (PlutoGridOnLoadedEvent event) {
//                   _stateManager = event.stateManager;
//                 },
//                 configuration: PlutoGridConfiguration(
//                   columnFilter: const PlutoGridColumnFilterConfig(
//                     filters: FilterHelper.defaultFilters,
//                   ),
//                   style: PlutoGridStyleConfig(
//                     enableColumnBorderVertical: true,
//                     gridBorderRadius: BorderRadius.circular(8),
//                     oddRowColor: Colors.blue[50],
//                     rowHeight: 35,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         if (_stateManager != null)
//           PlutoGridPagination(
//             stateManager: _stateManager!,
//             totalRows: _rows.length,
//             rowsPerPage: _rowsPerPage,
//             onPageChanged: (page, limit) {
//               setState(() {
//                 _currentPage = page;
//                 _rowsPerPage = limit;
//               });
//               _updatePagedRows();
//             },
//           ),
//       ],
//     );
//   }

//   Widget _buildLeaseDetails() {
//     if (selectedLeaseId == null) return Container();

//     final lease = leasesData.firstWhere((l) => l.id == selectedLeaseId);

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             // Close button
//             IconButton(
//               icon: const Icon(Icons.close),
//               color: Colors.blue,
//               iconSize: 30,
//               onPressed: () {
//                 setState(() {
//                   showLeaseDetails = false;
//                   selectedLeaseId = null;
//                 });
//               },
//               tooltip: 'Back to List',
//             ),
//             const SizedBox(height: 20),
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         lease.code,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         lease.description,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(lease.status).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: _getStatusColor(lease.status)),
//                   ),
//                   child: Text(
//                     lease.status.toUpperCase(),
//                     style: TextStyle(
//                       color: _getStatusColor(lease.status),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 24),

//             // Lease Details
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Basic Information
//                     _buildDetailSection('Basic Information', [
//                       _buildDetailRow('Lease Type', lease.leaseType),
//                       _buildDetailRow('Leasor Name', lease.leasorName),
//                       _buildDetailRow('Description', lease.description),
//                       _buildDetailRow('Reason', lease.reason),
//                     ]),

//                     const SizedBox(height: 20),

//                     // Contract Details
//                     _buildDetailSection('Contract Details', [
//                       _buildDetailRowWithCurrency(
//                         'Contract Amount',
//                         lease.contractAmount,
//                         lease.currency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Deposit',
//                         lease.deposit,
//                         lease.currency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Present Value',
//                         lease.presentValue,
//                         lease.currency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Down Payment',
//                         lease.downPayment,
//                         lease.currency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Other Cost',
//                         lease.otherCost,
//                         lease.currency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Dismantling Cost',
//                         lease.dismantlingCost,
//                         lease.currency,
//                       ),
//                     ]),

//                     const SizedBox(height: 20),

//                     // Date Information
//                     _buildDetailSection('Date Information', [
//                       _buildDetailRow(
//                         'Contract Date',
//                         DateFormat('yyyy-MM-dd').format(lease.contractDate),
//                       ),
//                       _buildDetailRow(
//                         'Start Date',
//                         DateFormat('yyyy-MM-dd').format(lease.startDate),
//                       ),
//                       _buildDetailRow(
//                         'End Date',
//                         DateFormat('yyyy-MM-dd').format(lease.endDate),
//                       ),
//                       _buildDetailRow(
//                         'Lease Term',
//                         '${lease.leaseTerm} ${lease.leasePeriod}',
//                       ),
//                     ]),

//                     const SizedBox(height: 20),

//                     // Payment Details
//                     _buildDetailSection('Payment Details', [
//                       _buildDetailRowWithCurrency(
//                         'Payment Amount',
//                         lease.paymentAmount,
//                         lease.currency,
//                       ),
//                       _buildDetailRow('Payment Period', lease.paymentPeriod),
//                       _buildDetailRow(
//                         'Discount Rate',
//                         '${lease.discountRate}%',
//                       ),
//                       _buildDetailRow('Computation Method', lease.computation),
//                     ]),

//                     if (lease.changingDate != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 20),
//                           _buildDetailSection('Change Information', [
//                             _buildDetailRow(
//                               'Changing Date',
//                               DateFormat(
//                                 'yyyy-MM-dd',
//                               ).format(lease.changingDate!),
//                             ),
//                             _buildDetailRowWithCurrency(
//                               'Changing Amount',
//                               lease.changingAmount,
//                               lease.currency,
//                             ),
//                           ]),
//                         ],
//                       ),

//                     const SizedBox(height: 20),

//                     // Currency Information
//                     _buildDetailSection('Currency Information', [
//                       _buildDetailRow('Transaction Currency', lease.currency),
//                       _buildDetailRow('Home Currency', lease.homeCurrency),
//                       _buildDetailRow(
//                         'Exchange Rate',
//                         lease.exchangeRate > 0
//                             ? lease.exchangeRate.toStringAsFixed(4)
//                             : 'N/A',
//                       ),
//                     ]),

//                     // Summary
//                     const SizedBox(height: 20),
//                     _buildDetailSection('Summary', [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.green[50],
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.green.shade200),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total Contract Value:',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                                 color: Colors.green[800],
//                               ),
//                             ),
//                             Text(
//                               '${_getCurrencySymbol(lease.currency)} ${lease.contractAmount.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.green,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ]),
//                   ],
//                 ),
//               ),
//             ),

//             // Close Button
//             const SizedBox(height: 16),
//             Center(
//               child: OutlinedButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     showLeaseDetails = false;
//                     selectedLeaseId = null;
//                   });
//                 },
//                 icon: const Icon(Icons.close, size: 16),
//                 label: const Text('Close Details'),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 12,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailSection(String title, List<Widget> children) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.blue,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Card(
//           elevation: 2,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(children: children),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRowWithCurrency(
//     String label,
//     double amount,
//     String currency,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             flex: 3,
//             child: Text(
//               '${_getCurrencySymbol(currency)} ${amount.toStringAsFixed(2)}',
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'active':
//         return Colors.green;
//       case 'completed':
//         return Colors.blue;
//       case 'amendment':
//         return Colors.orange;
//       case 'cancelled':
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }

//   String _getCurrencySymbol(String currency) {
//     switch (currency) {
//       case 'USD':
//         return '\$';
//       case 'MMK':
//         return 'Ks';
//       default:
//         return currency;
//     }
//   }
// }

// import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/screens/date_filter.dart';
import 'package:fixed_asset_frontend/screens/pagination.dart';
import 'package:fixed_asset_frontend/screens/search_function.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';

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

// NEW CLASS: Lease Schedule Entry
class LeaseScheduleEntry {
  final int period;
  final double openingLeaseLiability;
  final double interest;
  final double leasePayment;
  final double closingLeaseLiability;
  final double openingROUAsset;
  final double rOUDepreciation;
  final double closingROUAsset;
  final double shortTermLease;
  final double longTermLease;

  LeaseScheduleEntry({
    required this.period,
    required this.openingLeaseLiability,
    required this.interest,
    required this.leasePayment,
    required this.closingLeaseLiability,
    required this.openingROUAsset,
    required this.rOUDepreciation,
    required this.closingROUAsset,
    required this.shortTermLease,
    required this.longTermLease,
  });

  Map<String, dynamic> toJson() {
    return {
      'period': period,
      'opening_lease_liability': openingLeaseLiability,
      'interest': interest,
      'lease_payment': leasePayment,
      'closing_lease_liability': closingLeaseLiability,
      'opening_rou_asset': openingROUAsset,
      'rou_depreciation': rOUDepreciation,
      'closing_rou_asset': closingROUAsset,
      'short_term_lease': shortTermLease,
      'long_term_lease': longTermLease,
    };
  }
}

// NEW CLASS: Lease Schedule
class LeaseSchedule {
  final Leases lease;
  final List<LeaseScheduleEntry> entries;
  final double discountRate;

  LeaseSchedule({
    required this.lease,
    required this.entries,
    required this.discountRate,
  });
}

class Leaselist extends StatefulWidget {
  const Leaselist({super.key});

  @override
  State<Leaselist> createState() => _LeaselistState();
}

class _LeaselistState extends State<Leaselist> {
  PlutoGridStateManager? _stateManager;
  int? selectedLeaseId;
  bool showLeaseDetails = false;
  List<PlutoColumn> _columns = [];
  List<PlutoRow> _rows = [];
  List<PlutoRow> _pagedRows = [];
  List<Leases> leasesData = [];
  List<Leases> _filteredLeases = [];
  DateTimeRange? _currentDateRange;
  String? _currentFilterType;
  String _searchQuery = '';
  int _currentPage = 1;
  int _rowsPerPage = 10;
  LeaseSchedule? _currentSchedule;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _columns = _buildColumns();
  }

  void _initializeData() {
    // Using hardcoded data since no database yet
    final List<Map<String, dynamic>> leaseData = [
      {
        'id': 1,
        'code': 'L-001',
        'lease_type': 'Land',
        'description': 'South Dagon Land',
        'leasor_name': 'Su Su',
        'contract_amount': 2000000.0,
        'deposit': 700000.0,
        'present_value': 40000000.0,
        'down_payment': 300000.0,
        'other_cost': 600000.0,
        'currency': 'MMK',
        'home_currency': 'MMK',
        'exchange_rate': 0.0,
        'dismantling_cost': 500000.0,
        'contract_date': '2026-04-11',
        'start_date': '2026-04-12',
        'end_date': '2031-04-12',
        'lease_term': 5,
        'lease_period': 'year',
        'payment_amount': 2000000.0,
        'payment_period': 'per year',
        'discount_rate': 12.0,
        'computation': 'year',
        'changing_date': '2028-04-11',
        'changing_amount': 4000000.0,
        'status': 'Active',
        'reason': 'progress lease',
      },
      {
        'id': 2,
        'code': 'L-002',
        'lease_type': 'Building',
        'description': 'Office Building',
        'leasor_name': 'Mg Mg',
        'contract_amount': 5000000.0,
        'deposit': 1500000.0,
        'present_value': 80000000.0,
        'down_payment': 1000000.0,
        'other_cost': 800000.0,
        'currency': 'USD',
        'home_currency': 'MMK',
        'exchange_rate': 2100.0,
        'dismantling_cost': 700000.0,
        'contract_date': '2026-03-15',
        'start_date': '2026-04-01',
        'end_date': '2031-03-31',
        'lease_term': 5,
        'lease_period': 'year',
        'payment_amount': 1000000.0,
        'payment_period': 'per year',
        'discount_rate': 5.0,
        'computation': 'year',
        'changing_date': null,
        'changing_amount': 0.0,
        'status': 'Amendment',
        'reason': 'Amount Changed',
      },
      {
        'id': 3,
        'code': 'L-003',
        'lease_type': 'Equipment',
        'description': 'Construction Equipment',
        'leasor_name': 'Ko Ko',
        'contract_amount': 3000000.0,
        'deposit': 900000.0,
        'present_value': 25000000.0,
        'down_payment': 600000.0,
        'other_cost': 400000.0,
        'currency': 'MMK',
        'home_currency': 'MMK',
        'exchange_rate': 0.0,
        'dismantling_cost': 300000.0,
        'contract_date': '2026-02-20',
        'start_date': '2026-03-01',
        'end_date': '2029-02-28',
        'lease_term': 3,
        'lease_period': 'year',
        'payment_amount': 1000000.0,
        'payment_period': 'per year',
        'discount_rate': 7.0,
        'computation': 'month',
        'changing_date': '2027-02-20',
        'changing_amount': 3500000.0,
        'status': 'Completed',
        'reason': 'construction project',
      },
      {
        'id': 4,
        'code': 'L-004',
        'lease_type': 'Vehicle',
        'description': 'Delivery Truck',
        'leasor_name': 'Aung Aung',
        'contract_amount': 1500000.0,
        'deposit': 450000.0,
        'present_value': 12000000.0,
        'down_payment': 300000.0,
        'other_cost': 200000.0,
        'currency': 'MMK',
        'home_currency': 'MMK',
        'exchange_rate': 0.0,
        'dismantling_cost': 150000.0,
        'contract_date': '2026-01-10',
        'start_date': '2026-01-15',
        'end_date': '2028-01-14',
        'lease_term': 2,
        'lease_period': 'year',
        'payment_amount': 750000.0,
        'payment_period': 'per year',
        'discount_rate': 6.5,
        'computation': 'year',
        'changing_date': null,
        'changing_amount': 0.0,
        'status': 'Active',
        'reason': 'delivery service',
      },
      {
        'id': 5,
        'code': 'L-005',
        'lease_type': 'Land',
        'description': 'Industrial Plot',
        'leasor_name': 'Hla Hla',
        'contract_amount': 8000000.0,
        'deposit': 2400000.0,
        'present_value': 60000000.0,
        'down_payment': 1600000.0,
        'other_cost': 1200000.0,
        'currency': 'USD',
        'home_currency': 'MMK',
        'exchange_rate': 2100.0,
        'dismantling_cost': 1000000.0,
        'contract_date': '2025-12-01',
        'start_date': '2026-01-01',
        'end_date': '2036-12-31',
        'lease_term': 10,
        'lease_period': 'year',
        'payment_amount': 800000.0,
        'payment_period': 'per year',
        'discount_rate': 12.0,
        'computation': 'month',
        'changing_date': '2031-12-01',
        'changing_amount': 10000000.0,
        'status': 'Cancelled',
        'reason': 'terminated early',
      },
    ];

    setState(() {
      leasesData = leaseData.map((data) => Leases.fromJson(data)).toList();
      _filteredLeases = leasesData;
      _rows = _buildRows(_filteredLeases);
      _updatePagedRows();
    });
  }

  // NEW FUNCTION: Generate lease schedule
  LeaseSchedule _generateLeaseSchedule(Leases lease) {
    final discountRate = lease.discountRate / 100.0;
    final leaseTerm = lease.leaseTerm;
    final paymentAmount = lease.paymentAmount;
    final presentValue = lease.presentValue;

    // Determine computation type
    final isMonthly = lease.computation.toLowerCase().contains('month');
    final isQuarterly = lease.computation.toLowerCase().contains('quarter');
    final isYearly = lease.computation.toLowerCase().contains('year');

    int totalPeriods = leaseTerm;
    double periodicRate = discountRate;
    double periodicPayment = paymentAmount;

    if (isMonthly) {
      totalPeriods = leaseTerm * 12;
      periodicRate = discountRate / 12.0;
      periodicPayment = paymentAmount / 12.0;
    } else if (isQuarterly) {
      totalPeriods = leaseTerm * 4;
      periodicRate = discountRate / 4.0;
      periodicPayment = paymentAmount / 4.0;
    }

    List<LeaseScheduleEntry> entries = [];

    double openingLeaseLiability = presentValue;
    double openingROUAsset = presentValue;

    // Calculate depreciation based on computation type
    double periodicDepreciation;
    if (isMonthly) {
      periodicDepreciation = presentValue / (leaseTerm * 12);
    } else if (isQuarterly) {
      periodicDepreciation = presentValue / (leaseTerm * 4);
    } else {
      periodicDepreciation = presentValue / leaseTerm;
    }

    for (int period = 1; period <= totalPeriods; period++) {
      double interest = openingLeaseLiability * periodicRate;
      double principalPayment = periodicPayment - interest;
      double closingLeaseLiability = openingLeaseLiability - principalPayment;

      // Handle floating point errors in final period
      if (period == totalPeriods) {
        closingLeaseLiability = 0.0;
        principalPayment = openingLeaseLiability;
        interest = periodicPayment - principalPayment;
      }

      double depreciation = periodicDepreciation;
      double closingROUAsset = openingROUAsset - depreciation;

      // Handle floating point errors in final period for ROU Asset
      if (period == totalPeriods) {
        closingROUAsset = 0.0;
        depreciation = openingROUAsset;
      }

      // Calculate short-term vs long-term lease (simplified logic)
      double shortTermLease = 0.0;
      double longTermLease = 0.0;

      if (period == 1) {
        // For first period, allocate some amount as short-term
        // Based on your image: short term lease = lease payment * 0.1
        shortTermLease = periodicPayment * 0.1;
        longTermLease = closingLeaseLiability - shortTermLease;
      } else {
        shortTermLease = 0.0;
        longTermLease = closingLeaseLiability;
      }

      entries.add(
        LeaseScheduleEntry(
          period: period,
          openingLeaseLiability: double.parse(
            openingLeaseLiability.toStringAsFixed(2),
          ),
          interest: double.parse(interest.toStringAsFixed(2)),
          leasePayment: double.parse(periodicPayment.toStringAsFixed(2)),
          closingLeaseLiability: double.parse(
            closingLeaseLiability.toStringAsFixed(2),
          ),
          openingROUAsset: double.parse(openingROUAsset.toStringAsFixed(2)),
          rOUDepreciation: double.parse(depreciation.toStringAsFixed(2)),
          closingROUAsset: double.parse(closingROUAsset.toStringAsFixed(2)),
          shortTermLease: double.parse(shortTermLease.toStringAsFixed(2)),
          longTermLease: double.parse(longTermLease.toStringAsFixed(2)),
        ),
      );

      openingLeaseLiability = closingLeaseLiability;
      openingROUAsset = closingROUAsset;
    }

    return LeaseSchedule(
      lease: lease,
      entries: entries,
      discountRate: discountRate,
    );
  }

  // NEW FUNCTION: Show lease schedule dialog
  void _showLeaseSchedule(Leases lease) {
    final schedule = _generateLeaseSchedule(lease);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: _buildScheduleDialog(schedule),
        );
      },
    );
  }

  // NEW WIDGET: Build schedule dialog
  Widget _buildScheduleDialog(LeaseSchedule schedule) {
    final lease = schedule.lease;
    final entries = schedule.entries;
    final isMonthly = lease.computation.toLowerCase().contains('month');
    final isQuarterly = lease.computation.toLowerCase().contains('quarter');
    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    // Column widths for responsive design
    final columnWidths = {
      'period': 70.0,
      'opening_liability': 180.0,
      'interest': 130.0,
      'lease_payment': 150.0,
      'closing_liability': 180.0,
      'opening_rou': 180.0,
      'depreciation': 130.0,
      'closing_rou': 150.0,
    };

    final totalWidth = columnWidths.values.reduce((a, b) => a + b);

    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      constraints: BoxConstraints(
        maxWidth: 1200,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Lease Payment Schedule',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue[300]!),
                          ),
                          child: Text(
                            lease.code,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lease.description} • ${lease.leasorName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Computation: ${lease.computation} • Discount Rate: ${lease.discountRate}%',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 28, color: Colors.grey[700]),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ],
          ),

          // Schedule Summary
          Center(
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    _buildScheduleSummaryItem(
                      'Lease Term',
                      '${lease.leaseTerm} ${lease.leasePeriod}',
                      Icons.calendar_today,
                      Colors.blue[700]!,
                    ),
                    _buildScheduleSummaryItem(
                      'Payment Amount',
                      '${_getCurrencySymbol(lease.currency)} ${NumberFormat('#,##0.00').format(lease.paymentAmount)} ${isMonthly
                          ? '/month'
                          : isQuarterly
                          ? '/quarter'
                          : '/year'}',
                      Icons.payment,
                      Colors.green[700]!,
                    ),
                    _buildScheduleSummaryItem(
                      'Discount Rate',
                      '${lease.discountRate}%',
                      Icons.percent,
                      Colors.orange[700]!,
                    ),
                    _buildScheduleSummaryItem(
                      'Total Periods',
                      '${entries.length} ${_getPeriodUnit(lease.computation)}',
                      Icons.access_time,
                      Colors.purple[700]!,
                    ),
                    _buildScheduleSummaryItem(
                      'Present Value',
                      '${_getCurrencySymbol(lease.currency)} ${NumberFormat('#,##0.00').format(lease.presentValue)}',
                      Icons.attach_money,
                      Colors.teal[700]!,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Table Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Table Header - Fixed
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: totalWidth,
                        child: Row(
                          children: [
                            // Period
                            Container(
                              width: columnWidths['period'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  periodLabel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Opening Lease Liability
                            Container(
                              width: columnWidths['opening_liability'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Opening Lease\nLiability',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Interest
                            Container(
                              width: columnWidths['interest'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Interest\n(${lease.discountRate}%)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Lease Payment
                            Container(
                              width: columnWidths['lease_payment'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Lease\nPayment',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Closing Lease Liability
                            Container(
                              width: columnWidths['closing_liability'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Closing Lease\nLiability',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Opening ROU Asset
                            Container(
                              width: columnWidths['opening_rou'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Opening\nROU Asset',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // ROU Depreciation
                            Container(
                              width: columnWidths['depreciation'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ROU\nDepreciation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            // Closing ROU Asset
                            Container(
                              width: columnWidths['closing_rou'],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              decoration: const BoxDecoration(),
                              child: Center(
                                child: Text(
                                  'Closing\nROU Asset',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Table Body - Scrollable with fixed height
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: totalWidth,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              final entry = entries[index];
                              final isEven = index % 2 == 0;

                              return Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isEven
                                      ? Colors.grey[50]
                                      : Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Period
                                    Container(
                                      width: columnWidths['period'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          entry.period.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Opening Lease Liability
                                    Container(
                                      width: columnWidths['opening_liability'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.openingLeaseLiability),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Interest
                                    Container(
                                      width: columnWidths['interest'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.interest),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.orange[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Lease Payment
                                    Container(
                                      width: columnWidths['lease_payment'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.leasePayment),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.green[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Closing Lease Liability
                                    Container(
                                      width: columnWidths['closing_liability'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.closingLeaseLiability),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.purple[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Opening ROU Asset
                                    Container(
                                      width: columnWidths['opening_rou'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.openingROUAsset),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.teal[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // ROU Depreciation
                                    Container(
                                      width: columnWidths['depreciation'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: Colors.grey[300]!,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.rOUDepreciation),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.red[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Closing ROU Asset
                                    Container(
                                      width: columnWidths['closing_rou'],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Center(
                                        child: Text(
                                          NumberFormat(
                                            '#,##0.00',
                                          ).format(entry.closingROUAsset),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.brown[700],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Summary for First Entry
          if (entries.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(top: 20),
              color: Colors.green[50],
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.green[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'For ${periodLabel} 1 Entry',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Short Term Lease:',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_getCurrencySymbol(lease.currency)} ${NumberFormat('#,##0.00').format(entries[0].shortTermLease)}',
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.green[300],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Long Term Lease:',
                                style: TextStyle(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_getCurrencySymbol(lease.currency)} ${NumberFormat('#,##0.00').format(entries[0].longTermLease)}',
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Action Buttons
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.print, size: 20, color: Colors.white),
                label: Text('Print', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Print functionality will be implemented'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.download, size: 20, color: Colors.white),
                label: Text(
                  'Export to Excel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Export functionality will be implemented'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // NEW WIDGET: Build schedule summary item
  Widget _buildScheduleSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      constraints: BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _getPeriodUnit(String computation) {
    final comp = computation.toLowerCase();
    if (comp.contains('month')) {
      return 'months';
    } else if (comp.contains('year')) {
      return 'years';
    } else {
      return 'periods';
    }
  }

  void _applyFilter() {
    List<Leases> filtered = leasesData;

    // Apply date filter
    if (_currentDateRange != null) {
      final startDate = DateTime(
        _currentDateRange!.start.year,
        _currentDateRange!.start.month,
        _currentDateRange!.start.day,
      );
      final endDate = DateTime(
        _currentDateRange!.end.year,
        _currentDateRange!.end.month,
        _currentDateRange!.end.day,
      ).add(const Duration(days: 1));

      filtered = filtered.where((lease) {
        final leaseDate = DateTime(
          lease.startDate.year,
          lease.startDate.month,
          lease.startDate.day,
        );
        return leaseDate.isAtSameMomentAs(startDate) ||
            (leaseDate.isAfter(startDate) && leaseDate.isBefore(endDate));
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((lease) {
        return lease.code.toLowerCase().contains(query) ||
            lease.leaseType.toLowerCase().contains(query) ||
            lease.description.toLowerCase().contains(query) ||
            lease.leasorName.toLowerCase().contains(query) ||
            lease.status.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredLeases = filtered;
      _rows = _buildRows(_filteredLeases);
      _currentPage = 1;
      _updatePagedRows();
    });
  }

  void _updatePagedRows() {
    final start = (_currentPage - 1) * _rowsPerPage;
    final end = (_currentPage * _rowsPerPage).clamp(0, _rows.length);
    setState(() {
      _pagedRows = _rows.sublist(start, end);
    });

    if (_stateManager != null) {
      _stateManager!.removeAllRows();
      _stateManager!.appendRows(_pagedRows);
    }
  }

  void _handleDateRangeChange(DateTimeRange range, String selectedValue) {
    setState(() {
      _currentDateRange = range;
      _currentFilterType = selectedValue;
    });
    _applyFilter();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilter();
  }

  List<PlutoColumn> _buildColumns([double screenWidth = 1024]) {
    final isSmallScreen = screenWidth < 768;

    return [
      PlutoColumn(
        title: 'Code',
        field: 'code',
        readOnly: true,
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 80 : 100,
      ),
      PlutoColumn(
        title: 'Lease Type',
        field: 'lease_type',
        readOnly: true,
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 120,
      ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Description',
          field: 'description',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
          width: isSmallScreen ? 180 : 200,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Leasor Name',
          field: 'leasor_name',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
          width: isSmallScreen ? 100 : 150,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Contract Date',
          field: 'contract_date',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
          width: isSmallScreen ? 100 : 150,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Start Date',
          field: 'start_date',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.date(),
          width: isSmallScreen ? 90 : 110,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'End Date',
          field: 'end_date',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.date(),
          width: isSmallScreen ? 90 : 110,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Lease Term',
          field: 'lease_term',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
          width: isSmallScreen ? 80 : 100,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Lease Period',
          field: 'lease_period',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.text(),
          width: isSmallScreen ? 80 : 100,
        ),
      PlutoColumn(
        title: 'Contract Amount',
        field: 'contract_amount',
        readOnly: true,
        enableEditingMode: false,
        type: PlutoColumnType.number(),
        width: isSmallScreen ? 120 : 150,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.right,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final amount = row.cells['contract_amount']!.value;
          final currency = row.cells['currency']!.value;
          return Text(
            '$currency ${amount.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          );
        },
      ),

      PlutoColumn(
        title: 'Status',
        field: 'status',
        readOnly: true,
        enableEditingMode: false,
        type: PlutoColumnType.select(<String>[
          'active',
          'completed',
          'amendment',
          'cancelled',
        ]),
        width: isSmallScreen ? 100 : 120,
        renderer: (rendererContext) {
          final status = rendererContext.cell.value;
          Color color;
          switch (status.toLowerCase()) {
            case 'active':
              color = Colors.green;
            case 'completed':
              color = Colors.blue;
            case 'amendment':
              color = Colors.orange;
            case 'cancelled':
              color = Colors.red;
            default:
              color = Colors.grey;
          }
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                status,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 120 : 150,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final leaseCode = row.cells['code']!.value as String;
          final lease = leasesData.firstWhere((l) => l.code == leaseCode);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // View Details Button
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.visibility,
                    size: 18,
                    color: Colors.blue[700],
                  ),
                  onPressed: () {
                    _showLeaseDetails(lease.id);
                  },
                  tooltip: 'View Details',
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 6),

              // View Schedule Button - NEW
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.schedule,
                    size: 18,
                    color: Colors.purple[700],
                  ),
                  onPressed: () {
                    _showLeaseSchedule(lease);
                  },
                  tooltip: 'View Payment Schedule',
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          );
        },
      ),
      // Hidden columns
      PlutoColumn(
        title: 'id',
        field: 'id',
        type: PlutoColumnType.number(),
        width: 0,
        hide: true,
      ),
      PlutoColumn(
        title: 'currency',
        field: 'currency',
        type: PlutoColumnType.text(),
        width: 0,
        hide: true,
      ),
    ];
  }

  List<PlutoRow> _buildRows(List<Leases> leases) {
    return leases.map((lease) {
      return PlutoRow(
        key: ValueKey(lease.id),
        cells: {
          'code': PlutoCell(value: lease.code),
          'lease_type': PlutoCell(value: lease.leaseType),
          'description': PlutoCell(value: lease.description),
          'leasor_name': PlutoCell(value: lease.leasorName),
          'contract_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(lease.contractDate),
          ),
          'start_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(lease.startDate),
          ),
          'end_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(lease.endDate),
          ),
          'lease_term': PlutoCell(
            value: '${lease.leaseTerm} ${lease.leasePeriod}',
          ),
          'lease_period': PlutoCell(value: lease.leasePeriod),
          'contract_amount': PlutoCell(value: lease.contractAmount),
          'status': PlutoCell(value: lease.status),
          'actions': PlutoCell(value: ''),
          'id': PlutoCell(value: lease.id),
          'currency': PlutoCell(value: lease.currency),
        },
      );
    }).toList();
  }

  void _showLeaseDetails(int leaseId) {
    setState(() {
      selectedLeaseId = leaseId;
      showLeaseDetails = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1024;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Lease Register Lists',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Add new lease button
            if (!showLeaseDetails)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Add New Lease',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          // Navigate to lease form
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Filter and Search Bar
            if (!showLeaseDetails)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Flexible(
                      child: DateFilterDropdown(
                        onDateRangeChanged: _handleDateRangeChange,
                        selectedValue: _currentFilterType,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (_currentFilterType != null)
                      Chip(
                        label: Text(
                          'Filter: ${_currentFilterType!.replaceAll('_', ' ')}',
                        ),
                        backgroundColor: Colors.blue[50],
                        deleteIconColor: Colors.blue[700],
                        onDeleted: () {
                          setState(() {
                            _currentDateRange = null;
                            _currentFilterType = null;
                          });
                          _applyFilter();
                        },
                      ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: CustomSearchBar(
                        onSearch: _handleSearch,
                        hintText: 'Search by Lease Code, Type, Description...',
                        minWidth: 300,
                        maxWidth: 600,
                        initialValue: _searchQuery,
                      ),
                    ),
                  ],
                ),
              ),
            // Stats Summary Cards
            if (!showLeaseDetails) _buildStatsSummary(),
            const SizedBox(height: 16),

            // Main Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lease List Table
                  if (!showLeaseDetails)
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Table with fixed height
                          Expanded(child: _buildLeaseTable()),
                          // Pagination - ALWAYS VISIBLE (with null check)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: _buildPagination(),
                          ),
                        ],
                      ),
                    ),

                  // Lease Details Panel
                  if (showLeaseDetails && selectedLeaseId != null)
                    Expanded(flex: 1, child: _buildLeaseDetails()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    final totalLeases = _filteredLeases.length;
    final activeLeases = _filteredLeases
        .where((l) => l.status.toLowerCase() == 'active')
        .length;
    final completedLeases = _filteredLeases
        .where((l) => l.status.toLowerCase() == 'completed')
        .length;
    final amendmentLeases = _filteredLeases
        .where((l) => l.status.toLowerCase() == 'amendment')
        .length;
    final cancelLeases = _filteredLeases
        .where((l) => l.status.toLowerCase() == 'cancelled')
        .length;
    final totalContractValue = _filteredLeases.fold(
      0.0,
      (sum, lease) => sum + lease.contractAmount,
    );
    final avgContractValue = totalLeases > 0
        ? totalContractValue / totalLeases
        : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Leases',
            totalLeases.toString(),
            Icons.assignment,
            Colors.blue[700]!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Active Leases',
            activeLeases.toString(),
            Icons.check_circle,
            Colors.green[700]!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Completed',
            completedLeases.toString(),
            Icons.done_all,
            Colors.blue[700]!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Amendment',
            amendmentLeases.toString(),
            Icons.change_circle,
            Colors.orange[700]!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Cancelled',
            amendmentLeases.toString(),
            Icons.cancel,
            Colors.grey[700]!,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaseTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: PlutoGrid(
          columns: _columns,
          rows: _pagedRows,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            _stateManager = event.stateManager;
          },
          configuration: PlutoGridConfiguration(
            columnFilter: const PlutoGridColumnFilterConfig(
              filters: FilterHelper.defaultFilters,
            ),
            style: PlutoGridStyleConfig(
              enableColumnBorderVertical: true,
              gridBorderRadius: BorderRadius.circular(8),
              oddRowColor: Colors.blue[50],
              rowHeight: 35,
            ),
          ),
        ),
      ),
    );
  }

  // FIXED: Added null check for _stateManager
  Widget _buildPagination() {
    if (_stateManager == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Loading pagination...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: PlutoGridPagination(
          stateManager: _stateManager!,
          totalRows: _rows.length,
          rowsPerPage: _rowsPerPage,
          onPageChanged: (page, limit) {
            setState(() {
              _currentPage = page;
              _rowsPerPage = limit;
            });
            _updatePagedRows();
          },
        ),
      ),
    );
  }

  Widget _buildLeaseDetails() {
    if (selectedLeaseId == null) return Container();

    final lease = leasesData.firstWhere((l) => l.id == selectedLeaseId);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Close button
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.blue[700],
              iconSize: 30,
              onPressed: () {
                setState(() {
                  showLeaseDetails = false;
                  selectedLeaseId = null;
                });
              },
              tooltip: 'Back to List',
            ),
            const SizedBox(height: 20),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lease.code,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lease.description,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(lease.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(lease.status)),
                  ),
                  child: Text(
                    lease.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(lease.status),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Lease Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildDetailSection('Basic Information', [
                      _buildDetailRow('Lease Type', lease.leaseType),
                      _buildDetailRow('Leasor Name', lease.leasorName),
                      _buildDetailRow('Description', lease.description),
                      _buildDetailRow('Reason', lease.reason),
                    ]),

                    const SizedBox(height: 20),

                    // Contract Details
                    _buildDetailSection('Contract Details', [
                      _buildDetailRowWithCurrency(
                        'Contract Amount',
                        lease.contractAmount,
                        lease.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Deposit',
                        lease.deposit,
                        lease.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Present Value',
                        lease.presentValue,
                        lease.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Down Payment',
                        lease.downPayment,
                        lease.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Other Cost',
                        lease.otherCost,
                        lease.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Dismantling Cost',
                        lease.dismantlingCost,
                        lease.currency,
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Date Information
                    _buildDetailSection('Date Information', [
                      _buildDetailRow(
                        'Contract Date',
                        DateFormat('yyyy-MM-dd').format(lease.contractDate),
                      ),
                      _buildDetailRow(
                        'Start Date',
                        DateFormat('yyyy-MM-dd').format(lease.startDate),
                      ),
                      _buildDetailRow(
                        'End Date',
                        DateFormat('yyyy-MM-dd').format(lease.endDate),
                      ),
                      _buildDetailRow(
                        'Lease Term',
                        '${lease.leaseTerm} ${lease.leasePeriod}',
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Payment Details
                    _buildDetailSection('Payment Details', [
                      _buildDetailRowWithCurrency(
                        'Payment Amount',
                        lease.paymentAmount,
                        lease.currency,
                      ),
                      _buildDetailRow('Payment Period', lease.paymentPeriod),
                      _buildDetailRow(
                        'Discount Rate',
                        '${lease.discountRate}%',
                      ),
                      _buildDetailRow('Computation Method', lease.computation),
                    ]),

                    if (lease.changingDate != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildDetailSection('Change Information', [
                            _buildDetailRow(
                              'Changing Date',
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(lease.changingDate!),
                            ),
                            _buildDetailRowWithCurrency(
                              'Changing Amount',
                              lease.changingAmount,
                              lease.currency,
                            ),
                          ]),
                        ],
                      ),

                    const SizedBox(height: 20),

                    // Currency Information
                    _buildDetailSection('Currency Information', [
                      _buildDetailRow('Transaction Currency', lease.currency),
                      _buildDetailRow('Home Currency', lease.homeCurrency),
                      _buildDetailRow(
                        'Exchange Rate',
                        lease.exchangeRate > 0
                            ? lease.exchangeRate.toStringAsFixed(4)
                            : 'N/A',
                      ),
                    ]),

                    // View Schedule Button
                    const SizedBox(height: 20),
                    _buildDetailSection('Actions', [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'View Payment Schedule:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.purple[800],
                              ),
                            ),
                            ElevatedButton.icon(
                              icon: Icon(
                                Icons.schedule,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Open Schedule',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                _showLeaseSchedule(lease);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[700],
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),

                    // Summary
                    const SizedBox(height: 20),
                    _buildDetailSection('Summary', [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Contract Value:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green[800],
                              ),
                            ),
                            Text(
                              '${_getCurrencySymbol(lease.currency)} ${NumberFormat('#,##0.00').format(lease.contractAmount)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),

            // Close Button
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    showLeaseDetails = false;
                    selectedLeaseId = null;
                  });
                },
                icon: Icon(Icons.close, size: 16, color: Colors.grey[700]),
                label: Text(
                  'Close Details',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithCurrency(
    String label,
    double amount,
    String currency,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              '${_getCurrencySymbol(currency)} ${NumberFormat('#,##0.00').format(amount)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green[700]!;
      case 'completed':
        return Colors.blue[700]!;
      case 'amendment':
        return Colors.orange[700]!;
      case 'cancelled':
        return Colors.red[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'MMK':
        return 'Ks';
      default:
        return currency;
    }
  }
}
