// import 'package:fixed_asset_frontend/api/api_service.dart';
// import 'package:fixed_asset_frontend/api/data.dart';
// import 'package:fixed_asset_frontend/screens/search_function.dart';
// import 'package:flutter/material.dart';
// import 'package:pluto_grid/pluto_grid.dart';
// import 'package:intl/intl.dart';

// class FixedAssetListScreen extends StatefulWidget {
//   const FixedAssetListScreen({super.key});

//   @override
//   State<FixedAssetListScreen> createState() => _FixedAssetListScreenState();
// }

// class _FixedAssetListScreenState extends State<FixedAssetListScreen> {
//   PlutoGridStateManager? stateManager;
//   int? selectedAssetId;
//   bool showAssetDetails = false;
//   List<PlutoColumn> _columns = [];
//   List<PlutoRow> _rows = [];
//   List<PlutoRow> _pagedRows = [];
//   List<FixedAssets> fixedAssetData = [];
//   DateTimeRange? _currentDateRange;
//   String? _currentFilterType;
//   String _searchQuery = '';
//   int _currentPage = 1;
//   int _rowsPerPage = 10;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _fetchData() async {
//     try {
//       List<FixedAssets> fixedAssets = await ApiService().fetchFixedAssetData();
//       setState(() {
//         fixedAssetData = fixedAssets;
//       });
//       // _applyDateFilter();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load fixed Asset: ${e.toString()}')),
//       );
//     }
//   }

//   void _applyDateFilter() {
//     List<FixedAssets> filteredFixedAsset = fixedAssetData;
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

//       filteredFixedAsset = fixedAssetData.where((asset) {
//         final fixedAssetDate = DateTime(
//           asset.acquisitionDate.year,
//           asset.acquisitionDate.month,
//           asset.acquisitionDate.day,
//         );
//         return fixedAssetDate.isAtSameMomentAs(startDate) ||
//             (fixedAssetDate.isAfter(startDate) &&
//                 fixedAssetDate.isBefore(endDate));
//       }).toList();
//     }
//     if (_searchQuery.isNotEmpty) {
//       filteredFixedAsset = filteredFixedAsset
//           .where((asset) => SearchUtils.matchesSearchAsset(asset, _searchQuery))
//           .toList();
//     }

//     // final newRows = _buildRows(filteredFixedAsset);
//     // setState(() {
//     //   _rows = newRows;
//     //   _currentPage = 1;
//     // });
//     // _updatePagedRows();
//   }

//   void _updatePagedRow() {
//     final start = (_currentPage - 1) * _rowsPerPage;
//     final end = (_currentPage * _rowsPerPage).clamp(0, _rows.length);
//     setState(() {
//       _pagedRows = _rows.sublist(start, end);
//     });
//     if (stateManager != null) {
//       stateManager!.removeAllRows();
//       stateManager!.appendRows(_pagedRows);
//     }
//   }

//   void _handleDateRangeChange(DateTimeRange range, String selectedValue) {
//     setState(() {
//       _currentDateRange = range;
//       _currentFilterType = selectedValue;
//     });
//     _applyDateFilter();
//   }

//   void _handleSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//     _applyDateFilter();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Fixed Asset Register'),
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//         actions: [
//           if (showAssetDetails && selectedAssetId != null)
//             IconButton(
//               icon: const Icon(Icons.close),
//               onPressed: () {
//                 setState(() {
//                   showAssetDetails = false;
//                   selectedAssetId = null;
//                 });
//               },
//               tooltip: 'Back to List',
//             ),
//         ],
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Fixed Asset Register lists',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             // Stats Summary Cards
//             if (!showAssetDetails) _buildStatsSummary(),
//             const SizedBox(height: 16),

//             // Main Content
//             Expanded(
//               child: Row(
//                 children: [
//                   // Asset List Table
//                   if (!showAssetDetails)
//                     Expanded(flex: 2, child: _buildAssetTable(screenWidth)),

//                   // Asset Details Panel
//                   if (showAssetDetails && selectedAssetId != null)
//                     Expanded(flex: 1, child: _buildAssetDetails()),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsSummary() {
//     final totalAssets = fixedAssetData.length;
//     final totalValue = fixedAssetData.fold(
//       0.0,
//       (sum, asset) => sum + asset.totalAmount,
//     );
//     final activeAssets = fixedAssetData
//         .where(
//           (a) => a.assetStatus == 'ready to use' || a.assetStatus == 'finished',
//         )
//         .length;
//     final currencySymbol = fixedAssetData.isNotEmpty
//         ? _getCurrencySymbol(fixedAssetData.first.transactionCurrency)
//         : '';

//     return Row(
//       children: [
//         Expanded(
//           child: _buildStatCard(
//             'Total Assets',
//             totalAssets.toString(),
//             Icons.business,
//             Colors.blue,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Active Assets',
//             activeAssets.toString(),
//             Icons.check_circle,
//             Colors.green,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: _buildStatCard(
//             'Total Value',
//             '$currencySymbol ${totalValue.toStringAsFixed(0)}',
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
//         padding: const EdgeInsets.all(16),
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

//   Widget _buildAssetTable(double screenWidth) {
//     final isSmallScreen = screenWidth < 1024;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: PlutoGrid(
//           columns: _buildColumns(isSmallScreen),
//           rows: _buildRows(),
//           onLoaded: (PlutoGridOnLoadedEvent event) {
//             stateManager = event.stateManager;
//           },
//           configuration: PlutoGridConfiguration(
//             columnFilter: const PlutoGridColumnFilterConfig(
//               filters: FilterHelper.defaultFilters,
//             ),
//             style: PlutoGridStyleConfig(
//               enableColumnBorderVertical: true,
//               gridBorderRadius: BorderRadius.circular(8),
//             ),
//             columnSize: PlutoGridColumnSizeConfig(
//               autoSizeMode: PlutoAutoSizeMode.scale,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   List<PlutoColumn> _buildColumns(bool isSmallScreen) {
//     return [
//       PlutoColumn(
//         title: 'Fixed Asset Code',
//         field: 'fixed_asset_code',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 120 : 140,
//         renderer: (rendererContext) {
//           final value = rendererContext.cell.value;
//           return Center(
//             child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
//           );
//         },
//       ),
//       PlutoColumn(
//         title: 'Asset Group',
//         field: 'asset_group',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 110 : 130,
//       ),
//       PlutoColumn(
//         title: 'Asset Name',
//         field: 'asset_name',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 140 : 180,
//       ),
//       PlutoColumn(
//         title: 'Acquisition Date',
//         field: 'acquisition_date',
//         type: PlutoColumnType.date(),
//         width: isSmallScreen ? 100 : 120,
//       ),
//       PlutoColumn(
//         title: 'Capitalization Date',
//         field: 'capitalization_date',
//         type: PlutoColumnType.date(),
//         width: isSmallScreen ? 100 : 120,
//       ),
//       PlutoColumn(
//         title: 'Useful Life',
//         field: 'useful_life',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 90 : 100,
//       ),
//       PlutoColumn(
//         title: 'Period',
//         field: 'period',
//         type: PlutoColumnType.text(),
//         textAlign: PlutoColumnTextAlign.end,
//         titleTextAlign: PlutoColumnTextAlign.end,
//         width: isSmallScreen ? 130 : 150,
//       ),
//       PlutoColumn(
//         title: 'Home Currency',
//         field: 'home_currency',
//         textAlign: PlutoColumnTextAlign.right,
//         titleTextAlign: PlutoColumnTextAlign.right,
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 130 : 150,
//       ),
//       PlutoColumn(
//         title: 'Home Total Amount',
//         field: 'home_total_amount',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 120 : 140,
//       ),
//       PlutoColumn(
//         title: 'Home Accumulated Depreciation',
//         field: 'home_accumulated_depreciation',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 90 : 100,
//       ),
//       PlutoColumn(
//         title: 'Fixed Asset Account',
//         field: 'fixed_asset_account',
//         type: PlutoColumnType.text(),
//         width: isSmallScreen ? 90 : 100,
//       ),
//       PlutoColumn(
//         title: 'Actions',
//         field: 'actions',
//         type: PlutoColumnType.text(),
//         width: 80,
//         renderer: (rendererContext) {
//           // Get asset ID from the row data
//           final row = rendererContext.row;
//           final assetCode = row.cells['asset_code']!.value as String;

//           // Find the asset by assetCode to get the assetId
//           final asset = fixedAssetData.firstWhere(
//             (a) => a.fixedAssetCode == assetCode,
//           );

//           return Center(
//             child: IconButton(
//               icon: const Icon(Icons.visibility, size: 18),
//               onPressed: () {
//                 _showAssetDetails(asset.id);
//               },
//               tooltip: 'View Details',
//               color: Colors.blue,
//             ),
//           );
//         },
//       ),
//       // Hidden columns for rendering
//       PlutoColumn(
//         title: 'currency',
//         field: 'currency',
//         type: PlutoColumnType.text(),
//         width: 0,
//         hide: true,
//       ),
//     ];
//   }

//   List<PlutoRow> _buildRows() {
//     return fixedAssetData.map((asset) {
//       return PlutoRow(
//         key: ValueKey(asset.id),
//         cells: {
//           'fixed_asset_code': PlutoCell(value: asset.fixedAssetCode),
//           'asset_group': PlutoCell(value: asset.assetGroup),
//           'asset_name': PlutoCell(value: asset.assetName),
//           'acquisition_date': PlutoCell(
//             value: DateFormat('yyyy-MM-dd').format(asset.acquisitionDate),
//           ),
//           'capitalization_date': PlutoCell(
//             value: DateFormat('yyyy-MM-dd').format(asset.capitalizationDate),
//           ),
//           'useful_life': PlutoCell(value: asset.usefulLife),
//           'period': PlutoCell(value: asset.period),
//           'home_currency': PlutoCell(value: asset.homeCurrency),
//           'home_total_amount': PlutoCell(
//             value: asset.homeAcquisitionCost.toStringAsFixed(2),
//           ),
//           'home_accumulated_depreciation': PlutoCell(
//             value:
//                 double.tryParse(
//                   asset.depreciationAccount,
//                 )?.toStringAsFixed(2) ??
//                 asset.depreciationAccount,
//           ),
//           'fixed_asset_account': PlutoCell(value: asset.fixedAssetCode),
//           'actions': PlutoCell(value: ''),
//           'currency': PlutoCell(value: asset.transactionCurrency),
//         },
//       );
//     }).toList();
//   }

//   void _showAssetDetails(int assetId) {
//     setState(() {
//       selectedAssetId = assetId;
//       showAssetDetails = true;
//     });
//   }

//   Widget _buildAssetDetails() {
//     if (selectedAssetId == null) return Container();

//     final asset = fixedAssetData.firstWhere((a) => a.id == selectedAssetId);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 1200;

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         asset.fixedAssetCode,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         asset.assetName,
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
//                     color: _getStatusColor(asset.assetStatus).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(
//                       color: _getStatusColor(asset.assetStatus),
//                     ),
//                   ),
//                   child: Text(
//                     asset.assetStatus,
//                     style: TextStyle(
//                       color: _getStatusColor(asset.assetStatus),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(height: 24),

//             // Asset Details
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Basic Information
//                     _buildDetailSection('Basic Information', [
//                       _buildDetailRow('Asset Group', asset.assetGroup),
//                       _buildDetailRow('Asset Type', asset.assetType),
//                       _buildDetailRow('Source Type', asset.sourceType),
//                       _buildDetailRow(
//                         'Acquisition Date',
//                         DateFormat('yyyy-MM-dd').format(asset.acquisitionDate),
//                       ),
//                       _buildDetailRow('Supplier', asset.supplier),
//                       _buildDetailRow('Asset Model', asset.assetModel),
//                     ]),

//                     const SizedBox(height: 20),

//                     // Cost Details
//                     _buildDetailSection('Cost Details', [
//                       _buildDetailRowWithCurrency(
//                         'Acquisition Cost',
//                         asset.acquisitionCost,
//                         asset.transactionCurrency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Transportation Cost',
//                         asset.transportationFee,
//                         asset.transactionCurrency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Tax Fees',
//                         asset.tax,
//                         asset.transactionCurrency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Other Fees',
//                         asset.otherFee,
//                         asset.transactionCurrency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Additional Cost',
//                         asset.additionAmount,
//                         asset.transactionCurrency,
//                       ),
//                       _buildDetailRowWithCurrency(
//                         'Residual Value',
//                         asset.residualValue,
//                         asset.transactionCurrency,
//                       ),
//                       const Divider(height: 16),
//                       _buildDetailRowWithCurrency(
//                         'Total Amount',
//                         asset.totalAmount,
//                         asset.transactionCurrency,
//                         textStyle: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ]),

//                     const SizedBox(height: 20),

//                     // Account Details
//                     _buildDetailSection('Account Details', [
//                       _buildDetailRow(
//                         'Fixed Asset Account',
//                         asset.fixedAssetCode,
//                       ),
//                       _buildDetailRow(
//                         'Depreciation Account',
//                         asset.depreciationAccount,
//                       ),
//                       _buildDetailRow('Expense Account', asset.expenseAccount),
//                     ]),

//                     // Depreciation Details (if applicable)
//                     if (asset.assetStatus != 'No Depreciation' &&
//                         asset.depreciationMethod != null)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 20),
//                           _buildDetailSection('Depreciation Configuration', [
//                             _buildDetailRow(
//                               'Depreciation Method',
//                               asset.depreciationMethod,
//                             ),
//                             _buildDetailRow(
//                               'Capitalization Date',
//                               asset.capitalizationDate != null
//                                   ? DateFormat(
//                                       'yyyy-MM-dd',
//                                     ).format(asset.capitalizationDate)
//                                   : '',
//                             ),
//                             _buildDetailRow(
//                               'Useful Life',
//                               '${asset.usefulLife} ${asset.period ?? ''}',
//                             ),
//                             _buildDetailRow(
//                               'Computation Method',
//                               asset.computation ?? 'N/A',
//                             ),
//                           ]),
//                         ],
//                       ),

//                     // Description
//                     const SizedBox(height: 20),
//                     _buildDetailSection('Description', [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8),
//                         child: Text(
//                           asset.description,
//                           style: TextStyle(
//                             color: Colors.grey.shade700,
//                             fontSize: 14,
//                           ),
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
//                     showAssetDetails = false;
//                     selectedAssetId = null;
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
//     String currency, {
//     TextStyle? textStyle,
//   }) {
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
//               style: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'ready to use':
//         return Colors.blue;
//       case 'finished':
//         return Colors.green;
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

import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/screens/date_filter.dart';
import 'package:fixed_asset_frontend/screens/pagination.dart';
import 'package:fixed_asset_frontend/screens/search_function.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';

class FixedAssetListScreen extends StatefulWidget {
  const FixedAssetListScreen({super.key});

  @override
  State<FixedAssetListScreen> createState() => _FixedAssetListScreenState();
}

class _FixedAssetListScreenState extends State<FixedAssetListScreen> {
  PlutoGridStateManager? stateManager;
  int? selectedAssetId;
  bool showAssetDetails = false;
  List<PlutoColumn> _columns = [];
  List<PlutoRow> _rows = [];
  List<PlutoRow> _pagedRows = [];
  List<FixedAssets> fixedAssetData = [];
  List<FixedAssets> _filteredFixedAssetData = [];
  DateTimeRange? _currentDateRange;
  String? _currentFilterType;
  String _searchQuery = '';
  int _currentPage = 1;
  int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      List<FixedAssets> fixedAssets = await ApiService().fetchFixedAssetData();
      setState(() {
        fixedAssetData = fixedAssets;
        _filteredFixedAssetData = fixedAssets;
        _rows = _buildRows(_filteredFixedAssetData);
        _updatePagedRow();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load fixed Asset: ${e.toString()}')),
      );
    }
  }

  void _applyFilter() {
    List<FixedAssets> filtered = fixedAssetData;

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

      filtered = filtered.where((asset) {
        final assetDate = DateTime(
          asset.acquisitionDate.year,
          asset.acquisitionDate.month,
          asset.acquisitionDate.day,
        );
        return assetDate.isAtSameMomentAs(startDate) ||
            (assetDate.isAfter(startDate) && assetDate.isBefore(endDate));
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((asset) {
        return asset.fixedAssetCode.toLowerCase().contains(query) ||
            asset.assetName.toLowerCase().contains(query) ||
            asset.assetGroup.toLowerCase().contains(query) ||
            asset.assetStatus.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredFixedAssetData = filtered;
      _rows = _buildRows(_filteredFixedAssetData);
      _currentPage = 1;
      _updatePagedRow();
    });
  }

  void _updatePagedRow() {
    final start = (_currentPage - 1) * _rowsPerPage;
    final end = (_currentPage * _rowsPerPage).clamp(0, _rows.length);
    setState(() {
      _pagedRows = _rows.sublist(start, end);
    });

    if (stateManager != null) {
      stateManager!.removeAllRows();
      stateManager!.appendRows(_pagedRows);
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Asset Register'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          if (showAssetDetails && selectedAssetId != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  showAssetDetails = false;
                  selectedAssetId = null;
                });
              },
              tooltip: 'Back to List',
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Fixed Asset Register lists',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Filter and Search Bar
            if (!showAssetDetails)
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
                        hintText: 'Search by Asset Code, Name, Group...',
                        minWidth: 300,
                        maxWidth: 600,
                        initialValue: _searchQuery,
                      ),
                    ),
                  ],
                ),
              ),
            // Stats Summary Cards
            if (!showAssetDetails) _buildStatsSummary(),
            const SizedBox(height: 16),

            // Main Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Asset List Table
                  if (!showAssetDetails)
                    Expanded(flex: 2, child: _buildAssetTable(isSmallScreen)),

                  // Asset Details Panel
                  if (showAssetDetails && selectedAssetId != null)
                    Expanded(flex: 1, child: _buildAssetDetails()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSummary() {
    final totalAssets = _filteredFixedAssetData.length;
    final totalValue = _filteredFixedAssetData.fold(
      0.0,
      (sum, asset) => sum + asset.totalAmount,
    );
    final activeAssets = _filteredFixedAssetData
        .where(
          (a) => a.assetStatus == 'ready to use' || a.assetStatus == 'finished',
        )
        .length;
    final currencySymbol = _filteredFixedAssetData.isNotEmpty
        ? _getCurrencySymbol(_filteredFixedAssetData.first.transactionCurrency)
        : '';

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Assets',
            totalAssets.toString(),
            Icons.business,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Active Assets',
            activeAssets.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Value',
            '$currencySymbol ${totalValue.toStringAsFixed(0)}',
            Icons.attach_money,
            Colors.orange,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
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

  Widget _buildAssetTable(bool isSmallScreen) {
    if (_columns.isEmpty) {
      _columns = _buildColumns(isSmallScreen);
    }

    return Column(
      children: [
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: PlutoGrid(
                columns: _columns,
                rows: _pagedRows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
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
          ),
        ),
        const SizedBox(height: 10),
        if (stateManager != null)
          PlutoGridPagination(
            stateManager: stateManager!,
            totalRows: _rows.length,
            rowsPerPage: _rowsPerPage,
            onPageChanged: (page, limit) {
              setState(() {
                _currentPage = page;
                _rowsPerPage = limit;
              });
              _updatePagedRow();
            },
          ),
      ],
    );
  }

  List<PlutoColumn> _buildColumns(bool isSmallScreen) {
    return [
      // Column 1: fixed_asset_code
      PlutoColumn(
        title: 'Asset Code',
        field: 'fixed_asset_code',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 120,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          return Center(
            child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
          );
        },
      ),
      // Column 2: asset_group
      PlutoColumn(
        title: 'Asset Group',
        field: 'asset_group',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 130,
      ),
      // Column 3: asset_name
      PlutoColumn(
        title: 'Asset Name',
        field: 'asset_name',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 140 : 180,
      ),
      // Column 4: acquisition_date
      PlutoColumn(
        title: 'Acquisition Date',
        field: 'acquisition_date',
        type: PlutoColumnType.date(),
        width: isSmallScreen ? 100 : 120,
      ),
      // Column 5: capitalization_date
      PlutoColumn(
        title: 'Capitalization Date',
        field: 'capitalization_date',
        type: PlutoColumnType.date(),
        width: isSmallScreen ? 100 : 120,
      ),
      // Column 6: useful_life
      PlutoColumn(
        title: 'Useful Life',
        field: 'useful_life',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 90 : 100,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final usefulLife = row.cells['useful_life']!.value;
          final period = row.cells['period']!.value;
          return Center(
            child: Text(
              '$usefulLife $period',
              style: const TextStyle(fontSize: 14),
            ),
          );
        },
      ),
      // Column 7: period (hidden - used in useful_life column)
      PlutoColumn(
        title: 'period',
        field: 'period',
        type: PlutoColumnType.text(),
        width: 0,
        hide: true,
      ),
      // Column 8: home_currency
      PlutoColumn(
        title: 'Home Currency',
        field: 'home_currency',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 120,
      ),
      // Column 9: home_total_amount
      PlutoColumn(
        title: 'Home Total Amount',
        field: 'home_total_amount',
        type: PlutoColumnType.currency(),
        width: isSmallScreen ? 140 : 160,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final amount = row.cells['home_total_amount']!.value;
          final currency = row.cells['home_currency']!.value;
          return Center(
            child: Text(
              '$currency ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          );
        },
      ),
      // Column 10: home_accumulated_depreciation
      PlutoColumn(
        title: 'Home Accumulated Depreciation',
        field: 'home_accumulated_depreciation',
        type: PlutoColumnType.currency(),
        width: isSmallScreen ? 180 : 200,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final amount = row.cells['home_accumulated_depreciation']!.value;
          final currency = row.cells['home_currency']!.value;
          return Center(
            child: Text(
              '$currency ${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: isSmallScreen ? 12 : 14,
              ),
            ),
          );
        },
      ),
      // Column 11: home_fixed_asset_account
      PlutoColumn(
        title: 'Fixed Asset Acc',
        field: 'home_fixed_asset_account',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 180 : 200,
      ),
      // Column 12: Status
      PlutoColumn(
        title: 'Status',
        field: 'asset_status',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 120,
        renderer: (rendererContext) {
          final status = rendererContext.cell.value;
          Color color;
          switch (status) {
            case 'ready to use':
              color = Colors.blue;
            case 'finished':
              color = Colors.green;
            default:
              color = Colors.grey;
          }
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
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
      // Column 13: Actions
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 80 : 100,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final assetCode = row.cells['fixed_asset_code']!.value as String;

          // Find the asset by assetCode to get the assetId
          final asset = fixedAssetData.firstWhere(
            (a) => a.fixedAssetCode == assetCode,
          );

          return Center(
            child: IconButton(
              icon: const Icon(Icons.visibility, size: 18),
              onPressed: () {
                _showAssetDetails(asset.id);
              },
              tooltip: 'View Details',
              color: Colors.blue,
            ),
          );
        },
      ),
    ];
  }

  List<PlutoRow> _buildRows(List<FixedAssets> assets) {
    return assets.map((asset) {
      return PlutoRow(
        key: ValueKey(asset.id),
        cells: {
          // Column 1
          'fixed_asset_code': PlutoCell(value: asset.fixedAssetCode),
          // Column 2
          'asset_group': PlutoCell(value: asset.assetGroup),
          // Column 3
          'asset_name': PlutoCell(value: asset.assetName),
          // Column 4
          'acquisition_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(asset.acquisitionDate),
          ),
          // Column 5
          'capitalization_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(asset.capitalizationDate),
          ),
          // Column 6 (shows useful_life + period)
          'useful_life': PlutoCell(value: asset.usefulLife.toString()),
          // Column 7 (hidden)
          'period': PlutoCell(value: asset.period),
          // Column 8
          'home_currency': PlutoCell(value: asset.homeCurrency),
          // Column 9
          'home_total_amount': PlutoCell(value: asset.homeAcquisitionCost),
          // Column 10
          'home_accumulated_depreciation': PlutoCell(
            value: _calculateHomeAccumulatedDepreciation(asset),
          ),
          // Column 11
          'home_fixed_asset_account': PlutoCell(value: asset.fixedAssetAccount),
          // Column 12
          'asset_status': PlutoCell(value: asset.assetStatus),
          // Column 13
          'actions': PlutoCell(value: ''),
        },
      );
    }).toList();
  }

  double _calculateHomeAccumulatedDepreciation(FixedAssets asset) {
    if (asset.currentNbv > 0 && asset.homeAcquisitionCost > asset.currentNbv) {
      return asset.homeAcquisitionCost - asset.currentNbv;
    }
    return 0.0;
  }

  void _showAssetDetails(int assetId) {
    setState(() {
      selectedAssetId = assetId;
      showAssetDetails = true;
    });
  }

  Widget _buildAssetDetails() {
    if (selectedAssetId == null) return Container();

    final asset = fixedAssetData.firstWhere((a) => a.id == selectedAssetId);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
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
                      Text(
                        asset.fixedAssetCode,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        asset.assetName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
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
                    color: _getStatusColor(asset.assetStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(asset.assetStatus),
                    ),
                  ),
                  child: Text(
                    asset.assetStatus,
                    style: TextStyle(
                      color: _getStatusColor(asset.assetStatus),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Asset Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildDetailSection('Basic Information', [
                      _buildDetailRow('Asset Group', asset.assetGroup),
                      _buildDetailRow('Asset Type', asset.assetType),
                      _buildDetailRow('Source Type', asset.sourceType),
                      _buildDetailRow(
                        'Acquisition Date',
                        DateFormat('yyyy-MM-dd').format(asset.acquisitionDate),
                      ),
                      _buildDetailRow('Supplier', asset.supplier),
                      _buildDetailRow('Asset Model', asset.assetModel),
                    ]),

                    const SizedBox(height: 20),

                    // Home Currency Details
                    _buildDetailSection('Home Currency Details', [
                      _buildDetailRow('Home Currency', asset.homeCurrency),
                      _buildDetailRowWithCurrency(
                        'Home Acquisition Cost',
                        asset.homeAcquisitionCost,
                        asset.homeCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Home Accumulated Depreciation',
                        _calculateHomeAccumulatedDepreciation(asset),
                        asset.homeCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Home Current NBV',
                        asset.currentNbv,
                        asset.homeCurrency,
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Transaction Currency Details
                    _buildDetailSection('Transaction Currency Details', [
                      _buildDetailRow(
                        'Transaction Currency',
                        asset.transactionCurrency,
                      ),
                      _buildDetailRow(
                        'Exchange Rate',
                        asset.exchangeRate.toStringAsFixed(4),
                      ),
                      _buildDetailRowWithCurrency(
                        'Acquisition Cost',
                        asset.acquisitionCost,
                        asset.transactionCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Transportation Cost',
                        asset.transportationFee,
                        asset.transactionCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Tax Fees',
                        asset.tax,
                        asset.transactionCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Other Fees',
                        asset.otherFee,
                        asset.transactionCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Additional Cost',
                        asset.additionAmount,
                        asset.transactionCurrency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Residual Value',
                        asset.residualValue,
                        asset.transactionCurrency,
                      ),
                      const Divider(height: 16),
                      _buildDetailRowWithCurrency(
                        'Total Amount',
                        asset.totalAmount,
                        asset.transactionCurrency,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // Account Details
                    _buildDetailSection('Account Details', [
                      _buildDetailRow(
                        'Fixed Asset Account',
                        asset.fixedAssetCode,
                      ),
                      _buildDetailRow(
                        'Depreciation Account',
                        asset.depreciationAccount,
                      ),
                      _buildDetailRow('Expense Account', asset.expenseAccount),
                    ]),

                    // Depreciation Details (if applicable)
                    if (asset.depreciationMethod.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildDetailSection('Depreciation Configuration', [
                            _buildDetailRow(
                              'Depreciation Method',
                              asset.depreciationMethod,
                            ),
                            _buildDetailRow(
                              'Capitalization Date',
                              DateFormat(
                                'yyyy-MM-dd',
                              ).format(asset.capitalizationDate),
                            ),
                            _buildDetailRow(
                              'Useful Life',
                              '${asset.usefulLife} ${asset.period}',
                            ),
                            _buildDetailRow(
                              'Computation Method',
                              asset.computation,
                            ),
                          ]),
                        ],
                      ),

                    // Description
                    const SizedBox(height: 20),
                    _buildDetailSection('Description', [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          asset.description,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
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
                    showAssetDetails = false;
                    selectedAssetId = null;
                  });
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Close Details'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
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
                color: Colors.grey.shade700,
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
    String currency, {
    TextStyle? textStyle,
  }) {
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
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              '${_getCurrencySymbol(currency)} ${amount.toStringAsFixed(2)}',
              style: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ready to use':
        return Colors.blue;
      case 'finished':
        return Colors.green;
      default:
        return Colors.grey;
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
