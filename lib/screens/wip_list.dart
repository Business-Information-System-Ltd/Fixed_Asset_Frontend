import 'package:fixed_asset_frontend/screens/wip.dart';
import 'package:fixed_asset_frontend/screens/wip_item.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

// Mock Data Models
enum WIPStatus { progress, completed, capitalized }

class WIPProject {
  final int wipId;
  final String wipCode;
  final String projectName;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final WIPStatus status;
  final double totalAmount;
  final String currency;

  WIPProject({
    required this.wipId,
    required this.wipCode,
    required this.projectName,
    required this.startDate,
    this.endDate,
    required this.description,
    required this.status,
    required this.totalAmount,
    required this.currency,
  });
}

enum CostType { material, labor, equipment, overhead, other }

class WIPItem {
  final int wipItemId;
  final int wipId;
  final String itemCode;
  final String itemName;
  final Set<CostType> costType;
  final double quantity;
  final double unitCost;
  final double totalCost;
  final String currency;
  final DateTime transactionDate;
  final DateTime createdAt;

  WIPItem({
    required this.wipItemId,
    required this.wipId,
    required this.itemCode,
    required this.itemName,
    required this.costType,
    required this.quantity,
    required this.unitCost,
    required this.totalCost,
    required this.currency,
    required this.transactionDate,
    required this.createdAt,
  });
}

class WIPListScreen extends StatefulWidget {
  const WIPListScreen({Key? key}) : super(key: key);

  @override
  State<WIPListScreen> createState() => _WIPListScreenState();
}

class _WIPListScreenState extends State<WIPListScreen> {
  // Mock data for WIP projects
  final List<WIPProject> wipProjects = [
    WIPProject(
      wipId: 1,
      wipCode: 'WIP-2023-001',
      projectName: 'Office Building Construction',
      startDate: DateTime(2023, 1, 15),
      endDate: DateTime(2023, 12, 31),
      description: 'Main office building construction project',
      status: WIPStatus.progress,
      totalAmount: 2500000.0,
      currency: 'USD',
    ),
    WIPProject(
      wipId: 2,
      wipCode: 'WIP-2023-002',
      projectName: 'Highway Expansion',
      startDate: DateTime(2023, 3, 1),
      endDate: DateTime(2024, 6, 30),
      description: 'Highway expansion project - Phase 2',
      status: WIPStatus.capitalized,
      totalAmount: 18000000.0,
      currency: 'USD',
    ),
    WIPProject(
      wipId: 3,
      wipCode: 'WIP-2023-003',
      projectName: 'Residential Complex',
      startDate: DateTime(2023, 2, 10),
      endDate: DateTime(2023, 11, 15),
      description: 'Apartment complex with 50 units',
      status: WIPStatus.completed,
      totalAmount: 8500000.0,
      currency: 'MMK',
    ),
    WIPProject(
      wipId: 4,
      wipCode: 'WIP-2023-004',
      projectName: 'Bridge Renovation',
      startDate: DateTime(2023, 5, 1),
      endDate: DateTime(2025, 5, 1),
      description: 'Historical bridge restoration',
      status: WIPStatus.progress,
      totalAmount: 3200000.0,
      currency: 'MMK',
    ),
    WIPProject(
      wipId: 5,
      wipCode: 'WIP-2023-005',
      projectName: 'Shopping Mall',
      startDate: DateTime(2023, 6, 15),
      endDate: DateTime(2024, 8, 31),
      description: 'New shopping mall construction',
      status: WIPStatus.capitalized,
      totalAmount: 12500000.0,
      currency: 'USD',
    ),
  ];

  // Mock data for WIP items
  final List<WIPItem> wipItems = [
    // Items for project 1
    WIPItem(
      wipItemId: 1,
      wipId: 1,
      itemCode: 'CONC-001',
      itemName: 'Concrete Grade A',
      costType: {CostType.material},
      quantity: 500.0,
      unitCost: 150.0,
      totalCost: 75000.0,
      currency: 'USD',
      transactionDate: DateTime(2023, 2, 15),
      createdAt: DateTime(2023, 2, 15),
    ),
    WIPItem(
      wipItemId: 2,
      wipId: 1,
      itemCode: 'LAB-001',
      itemName: 'Mason Work',
      costType: {CostType.labor},
      quantity: 120.0,
      unitCost: 85.0,
      totalCost: 10200.0,
      currency: 'USD',
      transactionDate: DateTime(2023, 2, 20),
      createdAt: DateTime(2023, 2, 20),
    ),
    WIPItem(
      wipItemId: 8,
      wipId: 1,
      itemCode: 'STEEL-002',
      itemName: 'Rebar Steel',
      costType: {CostType.material},
      quantity: 300.0,
      unitCost: 200.0,
      totalCost: 60000.0,
      currency: 'USD',
      transactionDate: DateTime(2023, 3, 10),
      createdAt: DateTime(2023, 3, 10),
    ),
    // Items for project 2
    WIPItem(
      wipItemId: 3,
      wipId: 2,
      itemCode: 'ASPH-001',
      itemName: 'Asphalt Paving',
      costType: {CostType.material, CostType.labor},
      quantity: 2000.0,
      unitCost: 65.0,
      totalCost: 130000.0,
      currency: 'USD',
      transactionDate: DateTime(2023, 4, 10),
      createdAt: DateTime(2023, 4, 10),
    ),
    // Items for project 3
    WIPItem(
      wipItemId: 4,
      wipId: 3,
      itemCode: 'STEEL-001',
      itemName: 'Structural Steel',
      costType: {CostType.material, CostType.equipment},
      quantity: 150.0,
      unitCost: 1200.0,
      totalCost: 180000.0,
      currency: 'MMK',
      transactionDate: DateTime(2023, 3, 5),
      createdAt: DateTime(2023, 3, 5),
    ),
    WIPItem(
      wipItemId: 5,
      wipId: 3,
      itemCode: 'ELEC-001',
      itemName: 'Electrical Wiring',
      costType: {CostType.material, CostType.labor, CostType.overhead},
      quantity: 1.0,
      unitCost: 45000.0,
      totalCost: 45000.0,
      currency: 'MMK',
      transactionDate: DateTime(2023, 8, 22),
      createdAt: DateTime(2023, 8, 22),
    ),
    // Items for project 4
    WIPItem(
      wipItemId: 6,
      wipId: 4,
      itemCode: 'MAT-001',
      itemName: 'Historical Bricks',
      costType: {CostType.material},
      quantity: 5000.0,
      unitCost: 8.5,
      totalCost: 42500.0,
      currency: 'USD',
      transactionDate: DateTime(2023, 6, 15),
      createdAt: DateTime(2023, 6, 15),
    ),
    // Items for project 5
    WIPItem(
      wipItemId: 7,
      wipId: 5,
      itemCode: 'DES-001',
      itemName: 'Architectural Design',
      costType: {CostType.labor, CostType.overhead},
      quantity: 1.0,
      unitCost: 150000.0,
      totalCost: 150000.0,
      currency: 'USD',
      transactionDate: DateTime(2023, 7, 1),
      createdAt: DateTime(2023, 7, 1),
    ),
  ];

  late PlutoGridStateManager stateManager;
  int? expandedRowId;
  bool showWIPItems = false;
  List<WIPItem> currentProjectItems = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work In Progress (WIP) Projects'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            child: Text(
              'WIP Lists',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          Container(
            // width: 200,
            padding: EdgeInsets.fromLTRB(180, 50, 0, 0),
            child: Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  onPressed: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => WipForm())),
                  child: Text(
                    'Add New WIP Project',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              height: 600,
              constraints: BoxConstraints(
                maxWidth: screenWidth > 1200 ? 1200 : screenWidth * 0.95,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (!showWIPItems) _buildWIPTable(screenWidth),
                  if (showWIPItems && expandedRowId != null)
                    _buildWIPItemDetails(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWIPTable(double screenWidth) {
    return Expanded(
      child: PlutoGrid(
        columns: _buildColumns(screenWidth),
        rows: _buildRows(),
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          print(event);
        },
        configuration: PlutoGridConfiguration(
          columnFilter: const PlutoGridColumnFilterConfig(
            filters: FilterHelper.defaultFilters,
          ),
          style: PlutoGridStyleConfig(
            enableColumnBorderVertical: true,
            gridBorderRadius: BorderRadius.circular(8),
            // cellPadding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }

  List<PlutoColumn> _buildColumns(double screenWidth) {
    // Responsive column widths based on screen size
    final isSmallScreen = screenWidth < 768;
    final isMediumScreen = screenWidth < 1024;

    return [
      PlutoColumn(
        title: 'WIP Code',
        readOnly: true,
        field: 'wip_code',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 80 : (isMediumScreen ? 100 : 150),

        // enableRowChecked: true,
      ),
      PlutoColumn(
        title: 'Project Name',
        readOnly: true,
        field: 'project_name',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 120 : (isMediumScreen ? 300 : 350),
      ),

      PlutoColumn(
        title: 'Start Date',
        readOnly: true,
        field: 'start_date',
        type: PlutoColumnType.date(),
        width: isSmallScreen ? 90 : 120,
      ),
      PlutoColumn(
        title: 'End Date',
        readOnly: true,
        field: 'end_date',
        type: PlutoColumnType.date(),
        width: isSmallScreen ? 90 : 120,
      ),
      PlutoColumn(
        title: 'Status',
        readOnly: true,
        field: 'status',
        type: PlutoColumnType.select(<String>[
          'Progress',
          'Completed',
          'Capitalized',
        ]),
        width: isSmallScreen ? 100 : 120,
        renderer: (rendererContext) {
          final status = rendererContext.cell.value;
          Color color;
          switch (status) {
            case 'Progress':
              color = Colors.blue;
            case 'Completed':
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
      PlutoColumn(
        title: 'Total Amount',
        field: 'total_amount',
        readOnly: true,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.currency(),
        width: isSmallScreen ? 130 : 150,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final amount = row.cells['total_amount']!.value;
          final currency = row.cells['currency']!.value;
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
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: 150,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final wipCode = row.cells['wip_code']!.value as String;
          final project = wipProjects.firstWhere((p) => p.wipCode == wipCode);

          return Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   icon: const Icon(Icons.visibility, size: 20),
                //   onPressed: () {
                //     _showWIPItems(project.wipId);
                //   },
                //   tooltip: 'View WIP Items',
                // ),

                // View Items Button
                Tooltip(
                  message: 'View WIP Items',
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue.withOpacity(0.1),
                      // borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.remove_red_eye,
                        size: 18,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _showWIPItems(project.wipId);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Add Item Button
                Tooltip(
                  message: 'Add WIP Item',
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.green.withOpacity(0.1),
                      // borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        size: 18,
                        color: Colors.green,
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => WipItemForm()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Currency',
        field: 'currency',
        type: PlutoColumnType.text(),
        width: 80,
        hide: true,
      ),
    ];
  }

  List<PlutoRow> _buildRows() {
    return wipProjects.map((project) {
      return PlutoRow(
        key: ValueKey<int>(project.wipId),
        cells: {
          'wip_code': PlutoCell(value: project.wipCode),
          'project_name': PlutoCell(value: project.projectName),
          'start_date': PlutoCell(value: project.startDate),
          'end_date': PlutoCell(value: project.endDate),
          'status': PlutoCell(value: _getStatusText(project.status)),
          'total_amount': PlutoCell(value: project.totalAmount),
          'actions': PlutoCell(value: ''),
          'currency': PlutoCell(value: project.currency),
        },
      );
    }).toList();
  }

  void _showWIPItems(int projectId) {
    setState(() {
      expandedRowId = projectId;
      showWIPItems = true;
      currentProjectItems = wipItems
          .where((item) => item.wipId == projectId)
          .toList();
    });
  }

  Widget _buildWIPItemDetails() {
    if (expandedRowId == null) return Container();

    final project = wipProjects.firstWhere((p) => p.wipId == expandedRowId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'WIP Items: ${project.wipCode} - ${project.projectName}',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              showWIPItems = false;
                              expandedRowId = null;
                              currentProjectItems.clear();
                            });
                          },
                          tooltip: 'Back to Projects',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Project Summary',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSummaryItem(
                                'Status',
                                _getStatusText(project.status),
                                _getStatusColor(project.status),
                              ),
                              _buildSummaryItem(
                                'Start Date',
                                _formatDate(project.startDate),
                                Colors.blue,
                              ),
                              _buildSummaryItem(
                                'End Date',
                                _formatDate(project.endDate),
                                Colors.blue,
                              ),
                              _buildSummaryItem(
                                'Total Amount',
                                '${project.currency} ${project.totalAmount.toStringAsFixed(2)}',
                                Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'WIP Items (${currentProjectItems.length})',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (currentProjectItems.isEmpty)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          child: const Text(
                            'No WIP items found for this project',
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowColor: MaterialStateProperty.all(
                            Colors.blueGrey[50],
                          ),
                          dataRowHeight: 48,
                          columns: [
                            DataColumn(
                              label: Text(
                                'Code',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Item Name',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Cost Type',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Unit Cost',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Total Cost',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Date',
                                style: _tableHeaderStyle(isSmallScreen),
                              ),
                            ),
                          ],
                          rows: currentProjectItems.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    item.itemCode,
                                    style: _tableCellStyle(isSmallScreen),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.itemName,
                                    style: _tableCellStyle(isSmallScreen),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.costType
                                        .map((type) => _getCostTypeText(type))
                                        .join(', '),
                                    style: _tableCellStyle(isSmallScreen),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item.quantity.toStringAsFixed(2),
                                    style: _tableCellStyle(isSmallScreen),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.currency} ${item.unitCost.toStringAsFixed(2)}',
                                    style: _tableCellStyle(isSmallScreen),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.currency} ${item.totalCost.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatDate(item.transactionDate),
                                    style: _tableCellStyle(isSmallScreen),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Project Total:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                          ),
                          Text(
                            '${project.currency} ${project.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: isSmallScreen ? 16 : 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  TextStyle _tableHeaderStyle(bool isSmallScreen) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: isSmallScreen ? 12 : 14,
      color: Colors.blueGrey[800],
    );
  }

  TextStyle _tableCellStyle(bool isSmallScreen) {
    return TextStyle(fontSize: isSmallScreen ? 12 : 14);
  }

  String _getStatusText(WIPStatus status) {
    switch (status) {
      case WIPStatus.progress:
        return 'Progress';
      case WIPStatus.completed:
        return 'Completed';
      case WIPStatus.capitalized:
        return 'Capitalized';
    }
  }

  Color _getStatusColor(WIPStatus status) {
    switch (status) {
      case WIPStatus.capitalized:
        return Colors.grey;
      case WIPStatus.progress:
        return Colors.blue;
      case WIPStatus.completed:
        return Colors.green;
    }
  }

  String _getCostTypeText(CostType type) {
    switch (type) {
      case CostType.material:
        return 'Material';
      case CostType.labor:
        return 'Labor';
      case CostType.equipment:
        return 'Equipment';
      case CostType.overhead:
        return 'Overhead';
      case CostType.other:
        return 'Other';
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
