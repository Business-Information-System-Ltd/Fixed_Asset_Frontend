import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';

// Mock Data Models
enum AssetStatus { finished, readyToUse, noDepreciation, inProgress }

enum SourceType { wip, direct, generalLedger }

enum AssetType { main, component }

class FixedAsset {
  final int assetId;
  final String assetCode;
  final String assetName;
  final String assetGroup;
  final SourceType sourceType;
  final AssetType assetType;
  final DateTime acquisitionDate;
  final String description;
  final double acquisitionCost;
  final double transportationCost;
  final double taxFees;
  final double otherFees;
  final double additionalCost;
  final double residualValue;
  final double totalAmount;
  final AssetStatus assetStatus;
  final String fixedAssetAccountCode;
  final String depreciationAccountCode;
  final String expenseAccountCode;
  final String? depreciationMethod;
  final DateTime? capitalizationDate;
  final int? usefulLife;
  final String? usefulLifePeriod;
  final String? computationMethod;
  final String currency;
  final String supplier;
  final String assetModel;

  FixedAsset({
    required this.assetId,
    required this.assetCode,
    required this.assetName,
    required this.assetGroup,
    required this.sourceType,
    required this.assetType,
    required this.acquisitionDate,
    required this.description,
    required this.acquisitionCost,
    required this.transportationCost,
    required this.taxFees,
    required this.otherFees,
    required this.additionalCost,
    required this.residualValue,
    required this.totalAmount,
    required this.assetStatus,
    required this.fixedAssetAccountCode,
    required this.depreciationAccountCode,
    required this.expenseAccountCode,
    this.depreciationMethod,
    this.capitalizationDate,
    this.usefulLife,
    this.usefulLifePeriod,
    this.computationMethod,
    required this.currency,
    required this.supplier,
    required this.assetModel,
  });
}

class FixedAssetListScreen extends StatefulWidget {
  const FixedAssetListScreen({super.key});

  @override
  State<FixedAssetListScreen> createState() => _FixedAssetListScreenState();
}

class _FixedAssetListScreenState extends State<FixedAssetListScreen> {
  // Mock data for Fixed Assets
  final List<FixedAsset> fixedAssets = [
    FixedAsset(
      assetId: 1,
      assetCode: 'FA-2023-001',
      assetName: 'Office Building',
      assetGroup: 'Building',
      sourceType: SourceType.wip,
      assetType: AssetType.main,
      acquisitionDate: DateTime(2023, 1, 15),
      description: 'Main office building in downtown',
      acquisitionCost: 2000000.0,
      transportationCost: 50000.0,
      taxFees: 100000.0,
      otherFees: 50000.0,
      additionalCost: 0.0,
      residualValue: 200000.0,
      totalAmount: 2200000.0,
      assetStatus: AssetStatus.readyToUse,
      fixedAssetAccountCode: 'A_001',
      depreciationAccountCode: 'A_002',
      expenseAccountCode: 'A_003',
      depreciationMethod: 'Straight Line Method',
      capitalizationDate: DateTime(2023, 2, 1),
      usefulLife: 20,
      usefulLifePeriod: 'Year',
      computationMethod: 'Yearly',
      currency: 'MMK',
      supplier: 'ABC Construction',
      assetModel: 'Commercial Building',
    ),
    FixedAsset(
      assetId: 2,
      assetCode: 'FA-2023-002',
      assetName: 'Excavator Machine',
      assetGroup: 'Machine',
      sourceType: SourceType.direct,
      assetType: AssetType.main,
      acquisitionDate: DateTime(2023, 3, 10),
      description: 'Heavy duty excavator for construction',
      acquisitionCost: 150000.0,
      transportationCost: 10000.0,
      taxFees: 15000.0,
      otherFees: 5000.0,
      additionalCost: 20000.0,
      residualValue: 30000.0,
      totalAmount: 200000.0,
      assetStatus: AssetStatus.finished,
      fixedAssetAccountCode: 'A_002',
      depreciationAccountCode: 'A_003',
      expenseAccountCode: 'A_004',
      depreciationMethod: 'Reducing Method',
      capitalizationDate: DateTime(2023, 4, 1),
      usefulLife: 10,
      usefulLifePeriod: 'Year',
      computationMethod: 'Yearly',
      currency: 'USD',
      supplier: 'Caterpillar Inc.',
      assetModel: 'CAT 320',
    ),
    FixedAsset(
      assetId: 3,
      assetCode: 'FA-2023-003',
      assetName: 'Office Furniture Set',
      assetGroup: 'Furniture',
      sourceType: SourceType.generalLedger,
      assetType: AssetType.component,
      acquisitionDate: DateTime(2023, 2, 28),
      description: 'Complete office furniture including desks and chairs',
      acquisitionCost: 50000.0,
      transportationCost: 2000.0,
      taxFees: 5000.0,
      otherFees: 1000.0,
      additionalCost: 0.0,
      residualValue: 5000.0,
      totalAmount: 58000.0,
      assetStatus: AssetStatus.readyToUse,
      fixedAssetAccountCode: 'A_003',
      depreciationAccountCode: 'A_004',
      expenseAccountCode: 'A_005',
      depreciationMethod: 'Straight Line Method',
      capitalizationDate: DateTime(2023, 3, 15),
      usefulLife: 5,
      usefulLifePeriod: 'Year',
      computationMethod: 'Yearly',
      currency: 'MMK',
      supplier: 'Office Furniture Co.',
      assetModel: 'Executive Suite',
    ),
    FixedAsset(
      assetId: 4,
      assetCode: 'FA-2023-004',
      assetName: 'Land Plot',
      assetGroup: 'Land',
      sourceType: SourceType.direct,
      assetType: AssetType.main,
      acquisitionDate: DateTime(2023, 5, 20),
      description: 'Commercial land plot in industrial zone',
      acquisitionCost: 500000.0,
      transportationCost: 0.0,
      taxFees: 25000.0,
      otherFees: 5000.0,
      additionalCost: 0.0,
      residualValue: 0.0,
      totalAmount: 530000.0,
      assetStatus: AssetStatus.noDepreciation,
      fixedAssetAccountCode: 'A_004',
      depreciationAccountCode: 'N/A',
      expenseAccountCode: 'N/A',
      currency: 'MMK',
      supplier: 'Land Development Corp.',
      assetModel: 'Commercial Land',
    ),
    FixedAsset(
      assetId: 5,
      assetCode: 'FA-2023-005',
      assetName: 'Production Machine',
      assetGroup: 'Machine',
      sourceType: SourceType.wip,
      assetType: AssetType.main,
      acquisitionDate: DateTime(2023, 4, 5),
      description: 'Automated production line machine',
      acquisitionCost: 800000.0,
      transportationCost: 40000.0,
      taxFees: 80000.0,
      otherFees: 20000.0,
      additionalCost: 50000.0,
      residualValue: 100000.0,
      totalAmount: 990000.0,
      assetStatus: AssetStatus.inProgress,
      fixedAssetAccountCode: 'A_005',
      depreciationAccountCode: 'A_006',
      expenseAccountCode: 'A_007',
      depreciationMethod: 'Straight Line Method',
      capitalizationDate: DateTime(2023, 5, 1),
      usefulLife: 15,
      usefulLifePeriod: 'Year',
      computationMethod: 'Yearly',
      currency: 'USD',
      supplier: 'Siemens',
      assetModel: 'Automated Line',
    ),
  ];

  late PlutoGridStateManager stateManager;
  int? selectedAssetId;
  bool showAssetDetails = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
            // Stats Summary Cards
            if (!showAssetDetails) _buildStatsSummary(),
            const SizedBox(height: 16),

            // Main Content
            Expanded(
              child: Row(
                children: [
                  // Asset List Table
                  if (!showAssetDetails)
                    Expanded(flex: 2, child: _buildAssetTable(screenWidth)),

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
    final totalAssets = fixedAssets.length;
    final totalValue = fixedAssets.fold(
      0.0,
      (sum, asset) => sum + asset.totalAmount,
    );
    final activeAssets = fixedAssets
        .where(
          (a) =>
              a.assetStatus == AssetStatus.readyToUse ||
              a.assetStatus == AssetStatus.finished,
        )
        .length;

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
            '${_getCurrencySymbol(fixedAssets.first.currency)} ${totalValue.toStringAsFixed(0)}',
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

  Widget _buildAssetTable(double screenWidth) {
    final isSmallScreen = screenWidth < 1024;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: PlutoGrid(
          columns: _buildColumns(isSmallScreen),
          rows: _buildRows(),
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
            ),
            columnSize: PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale,
            ),
          ),
        ),
      ),
    );
  }

  List<PlutoColumn> _buildColumns(bool isSmallScreen) {
    return [
      PlutoColumn(
        title: 'Acquisition Date',
        field: 'acquisition_date',
        type: PlutoColumnType.text(), // FIXED: Changed to text()
        width: isSmallScreen ? 120 : 140,
        renderer: (rendererContext) {
          final value = rendererContext.cell.value;
          return Center(
            child: Text(value.toString(), style: const TextStyle(fontSize: 14)),
          );
        },
      ),
      PlutoColumn(
        title: 'Asset Code',
        field: 'asset_code',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 110 : 130,
      ),
      PlutoColumn(
        title: 'Asset Name',
        field: 'asset_name',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 140 : 180,
      ),
      PlutoColumn(
        title: 'Asset Group',
        field: 'asset_group',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 120,
      ),
      PlutoColumn(
        title: 'Source Type',
        field: 'source_type',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 100 : 120,
        renderer: (rendererContext) {
          final sourceType = rendererContext.cell.value as String;
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              // decoration: BoxDecoration(
              //   color: _getSourceTypeColor(sourceType).withOpacity(0.1),
              //   borderRadius: BorderRadius.circular(12),
              //   border: Border.all(
              //     color: _getSourceTypeColor(sourceType).withOpacity(0.3),
              //   ),
              // ),
              child: Text(
                sourceType,
                style: TextStyle(
                  color: _getSourceTypeColor(sourceType),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Asset Type',
        field: 'asset_type',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 90 : 100,
      ),
      PlutoColumn(
        title: 'Acquisition Cost',
        field: 'acquisition_cost',
        type: PlutoColumnType.text(),
        textAlign: PlutoColumnTextAlign.end,
        titleTextAlign: PlutoColumnTextAlign.end,
        width: isSmallScreen ? 130 : 150,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final cost = row.cells['acquisition_cost']!.value;
          final currency = row.cells['currency']!.value as String;

          return Center(
            child: Text(
              '${_getCurrencySymbol(currency)} $cost',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Total Amount',
        field: 'total_amount',
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.text(), // FIXED: Changed to text()
        width: isSmallScreen ? 130 : 150,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final amount = row.cells['total_amount']!.value;
          final currency = row.cells['currency']!.value as String;

          return Center(
            child: Text(
              '${_getCurrencySymbol(currency)} $amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                // fontSize: 12,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Asset Status',
        field: 'asset_status',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 120 : 140,
        renderer: (rendererContext) {
          final status = rendererContext.cell.value as String;
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              // decoration: BoxDecoration(
              //   color: _getStatusColor(status).withOpacity(0.1),
              //   borderRadius: BorderRadius.circular(12),
              //   border: Border.all(
              //     color: _getStatusColor(status).withOpacity(0.3),
              //   ),
              // ),
              child: Text(
                status,
                style: TextStyle(
                  color: _getStatusColor(status),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'FA Account',
        field: 'fa_account',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 90 : 100,
      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: 80,
        renderer: (rendererContext) {
          // Get asset ID from the row data
          final row = rendererContext.row;
          final assetCode = row.cells['asset_code']!.value as String;

          // Find the asset by assetCode to get the assetId
          final asset = fixedAssets.firstWhere((a) => a.assetCode == assetCode);

          return Center(
            child: IconButton(
              icon: const Icon(Icons.visibility, size: 18),
              onPressed: () {
                _showAssetDetails(asset.assetId);
              },
              tooltip: 'View Details',
              color: Colors.blue,
            ),
          );
        },
      ),
      // Hidden columns for rendering
      PlutoColumn(
        title: 'currency',
        field: 'currency',
        type: PlutoColumnType.text(),
        width: 0,
        hide: true,
      ),
    ];
  }

  List<PlutoRow> _buildRows() {
    return fixedAssets.map((asset) {
      return PlutoRow(
        key: ValueKey(asset.assetId),
        cells: {
          // FIXED: Store date as string
          'acquisition_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(asset.acquisitionDate),
          ),
          'asset_code': PlutoCell(value: asset.assetCode),
          'asset_name': PlutoCell(value: asset.assetName),
          'asset_group': PlutoCell(value: asset.assetGroup),
          'source_type': PlutoCell(value: _getSourceTypeText(asset.sourceType)),
          'asset_type': PlutoCell(value: _getAssetTypeText(asset.assetType)),
          // FIXED: Store numeric values as strings
          'acquisition_cost': PlutoCell(
            value: asset.acquisitionCost.toStringAsFixed(2),
          ),
          'total_amount': PlutoCell(
            value: asset.totalAmount.toStringAsFixed(2),
          ),
          'asset_status': PlutoCell(value: _getStatusText(asset.assetStatus)),
          'fa_account': PlutoCell(value: asset.fixedAssetAccountCode),
          'actions': PlutoCell(value: ''),
          'currency': PlutoCell(value: asset.currency),
        },
      );
    }).toList();
  }

  void _showAssetDetails(int assetId) {
    setState(() {
      selectedAssetId = assetId;
      showAssetDetails = true;
    });
  }

  Widget _buildAssetDetails() {
    if (selectedAssetId == null) return Container();

    final asset = fixedAssets.firstWhere((a) => a.assetId == selectedAssetId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 1200;

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
                        asset.assetCode,
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
                    color: _getStatusColor(
                      _getStatusText(asset.assetStatus),
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(
                        _getStatusText(asset.assetStatus),
                      ).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _getStatusText(asset.assetStatus),
                    style: TextStyle(
                      color: _getStatusColor(_getStatusText(asset.assetStatus)),
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
                      _buildDetailRow(
                        'Asset Type',
                        _getAssetTypeText(asset.assetType),
                      ),
                      _buildDetailRow(
                        'Source Type',
                        _getSourceTypeText(asset.sourceType),
                      ),
                      _buildDetailRow(
                        'Acquisition Date',
                        DateFormat('yyyy-MM-dd').format(asset.acquisitionDate),
                      ),
                      _buildDetailRow('Supplier', asset.supplier),
                      _buildDetailRow('Asset Model', asset.assetModel),
                    ]),

                    const SizedBox(height: 20),

                    // Cost Details
                    _buildDetailSection('Cost Details', [
                      _buildDetailRowWithCurrency(
                        'Acquisition Cost',
                        asset.acquisitionCost,
                        asset.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Transportation Cost',
                        asset.transportationCost,
                        asset.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Tax Fees',
                        asset.taxFees,
                        asset.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Other Fees',
                        asset.otherFees,
                        asset.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Additional Cost',
                        asset.additionalCost,
                        asset.currency,
                      ),
                      _buildDetailRowWithCurrency(
                        'Residual Value',
                        asset.residualValue,
                        asset.currency,
                      ),
                      const Divider(height: 16),
                      _buildDetailRowWithCurrency(
                        'Total Amount',
                        asset.totalAmount,
                        asset.currency,
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
                        asset.fixedAssetAccountCode,
                      ),
                      _buildDetailRow(
                        'Depreciation Account',
                        asset.depreciationAccountCode,
                      ),
                      _buildDetailRow(
                        'Expense Account',
                        asset.expenseAccountCode,
                      ),
                    ]),

                    // Depreciation Details (if applicable)
                    if (asset.assetStatus != AssetStatus.noDepreciation &&
                        asset.depreciationMethod != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildDetailSection('Depreciation Configuration', [
                            _buildDetailRow(
                              'Depreciation Method',
                              asset.depreciationMethod!,
                            ),
                            _buildDetailRow(
                              'Capitalization Date',
                              asset.capitalizationDate != null
                                  ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(asset.capitalizationDate!)
                                  : 'N/A',
                            ),
                            _buildDetailRow(
                              'Useful Life',
                              '${asset.usefulLife} ${asset.usefulLifePeriod ?? ''}',
                            ),
                            _buildDetailRow(
                              'Computation Method',
                              asset.computationMethod ?? 'N/A',
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

  // Helper Methods
  String _getStatusText(AssetStatus status) {
    switch (status) {
      case AssetStatus.finished:
        return 'Finished';
      case AssetStatus.readyToUse:
        return 'Ready to use';
      case AssetStatus.noDepreciation:
        return 'No depreciation';
      case AssetStatus.inProgress:
        return 'In Progress';
    }
  }

  String _getSourceTypeText(SourceType sourceType) {
    switch (sourceType) {
      case SourceType.wip:
        return 'WIP';
      case SourceType.direct:
        return 'Direct';
      case SourceType.generalLedger:
        return 'General Ledger';
    }
  }

  String _getAssetTypeText(AssetType assetType) {
    switch (assetType) {
      case AssetType.main:
        return 'Main';
      case AssetType.component:
        return 'Component';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Finished':
        return Colors.green;
      case 'Ready to use':
        return Colors.blue;
      case 'No depreciation':
        return Colors.orange;
      case 'In Progress':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getSourceTypeColor(String sourceType) {
    switch (sourceType) {
      case 'WIP':
        return Colors.purple;
      case 'Direct':
        return Colors.blue;
      case 'General Ledger':
        return Colors.teal;
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
