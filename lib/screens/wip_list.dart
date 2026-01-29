import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/screens/date_filter.dart';
import 'package:fixed_asset_frontend/screens/pagination.dart';
import 'package:fixed_asset_frontend/screens/search_function.dart';
import 'package:fixed_asset_frontend/screens/wip.dart';
import 'package:fixed_asset_frontend/screens/wip_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class WIPListScreen extends StatefulWidget {
  const WIPListScreen({Key? key}) : super(key: key);

  @override
  State<WIPListScreen> createState() => _WIPListScreenState();
}

class _WIPListScreenState extends State<WIPListScreen> {
  PlutoGridStateManager? _stateManager;
  int? expandedRowId;
  bool showWIPItems = false;
  String _searchQuery = '';
  List<Wip> wipData = [];
  List<WipItem> wipItemData = [];
  List<WipItem> _filteredWipItems = [];
  DateTimeRange? _currentDateRange;
  String? _currentFilterType;
  List<PlutoColumn> _columns = [];
  List<PlutoRow> _rows = [];
  List<PlutoRow> _pagedRows = [];
  int _currentPage = 1;
  int _rowsPerPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _columns = _buildColumns();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() async {
    try {
      List<Wip> data = await ApiService().fetchWipData();
      List<WipItem> wipItem = await ApiService().fetchWipItemData();
      setState(() {
        wipData = data;
        wipItemData = wipItem;
        print("Wip count: ${data.length}");
        print("Wip_item count: ${wipItem.length}");
      });
      _applyDateFilter();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
      );
    }
  }

  //date filter
  void _applyDateFilter() {
    List<Wip> filteredWip = wipData;

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

      filteredWip = wipData.where((wip) {
        final wipDate = DateTime(
          wip.startDate.year,
          wip.startDate.month,
          wip.startDate.day,
        );
        return wipDate.isAtSameMomentAs(startDate) ||
            (wipDate.isAfter(startDate) && wipDate.isBefore(endDate));
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredWip = filteredWip.where((wip) {
        return wip.wipCode.toLowerCase().contains(query) ||
            wip.projectName.toLowerCase().contains(query) ||
            wip.description.toLowerCase().contains(query) ||
            wip.status.toLowerCase().contains(query);
      }).toList();
    }

    final newRows = _buildRows(filteredWip);
    setState(() {
      _rows = newRows;
      _currentPage = 1;
    });
    _updatePagedRows();
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
    _applyDateFilter();
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyDateFilter();
  }

  List<PlutoColumn> _buildColumns([double screenWidth = 1024]) {
    // Responsive column widths based on screen size
    final isSmallScreen = screenWidth < 768;
    final isMediumScreen = screenWidth < 1024;

    return [
      PlutoColumn(
        title: 'WIP Code',
        readOnly: true,
        enableEditingMode: false,
        field: 'wip_code',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 80 : (isMediumScreen ? 100 : 150),
      ),
      PlutoColumn(
        title: 'Project Name',
        readOnly: true,
        enableEditingMode: false,
        field: 'project_name',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 120 : (isMediumScreen ? 300 : 350),
      ),
      PlutoColumn(
        title: 'Project Description',
        readOnly: true,
        enableEditingMode: false,
        field: 'project_description',
        type: PlutoColumnType.text(),
        width: isSmallScreen ? 120 : (isMediumScreen ? 300 : 350),
      ),
      PlutoColumn(
        title: 'Start Date',
        readOnly: true,
        enableEditingMode: false,
        field: 'start_date',
        type: PlutoColumnType.date(),
        width: isSmallScreen ? 90 : 120,
      ),
      PlutoColumn(
        title: 'End Date',
        readOnly: true,
        enableEditingMode: false,
        field: 'end_date',
        type: PlutoColumnType.date(),
        width: isSmallScreen ? 90 : 120,
      ),
      PlutoColumn(
        title: 'Status',
        readOnly: true,
        enableEditingMode: false,
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
        enableEditingMode: false,
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
        enableEditingMode: false,
        type: PlutoColumnType.text(),
        width: 150,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final wipCode = row.cells['wip_code']!.value as String;
          final project = wipData.firstWhere((p) => p.wipCode == wipCode);

          return Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // View Items Button
                Tooltip(
                  message: 'View WIP Items',
                  child: IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye,
                      size: 18,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      _showWIPItems(project.id);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Add Item Button
                Tooltip(
                  message: 'Add WIP Item',
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

  List<PlutoRow> _buildRows(List<Wip> wipProjects) {
    return wipProjects.map((project) {
      return PlutoRow(
        key: ValueKey<int>(project.id),
        cells: {
          'wip_code': PlutoCell(value: project.wipCode),
          'project_name': PlutoCell(value: project.projectName),
          'project_description': PlutoCell(value: project.description),
          'start_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(project.startDate),
          ),
          'end_date': PlutoCell(
            value: DateFormat('yyyy-MM-dd').format(project.endDate),
          ),
          'status': PlutoCell(value: project.status),
          'total_amount': PlutoCell(value: project.totalAmount),
          'actions': PlutoCell(value: ''),
          'currency': PlutoCell(value: project.currency),
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work In Progress (WIP) Projects'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              alignment: Alignment.centerLeft,
              child: Center(
                child: const Text(
                  'WIP Lists',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (!showWIPItems)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        'Add New WIP Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WipForm()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Filter and Search Row
            if (!showWIPItems)
              Row(
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
                        _applyDateFilter();
                      },
                    ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: CustomSearchBar(
                      onSearch: _handleSearch,
                      hintText: 'Search by WIP Code, Project Name...',
                      minWidth: 300,
                      maxWidth: 600,
                      initialValue: _searchQuery,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Expanded(
              child: showWIPItems && expandedRowId != null
                  ? _buildWIPItemDetails()
                  : _buildWIPTable(screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWIPTable(double screenWidth) {
    return Column(
      children: [
        Expanded(
          child: PlutoGrid(
            columns: _columns,
            rows: _pagedRows,
            mode: PlutoGridMode.normal,
            onLoaded: (PlutoGridOnLoadedEvent event) {
              _stateManager = event.stateManager;
              _updatePagedRows();
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
                oddRowColor: Colors.blue[50],
                rowHeight: 35,
                activatedColor: Colors.lightBlueAccent.withOpacity(0.2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_stateManager != null)
          PlutoGridPagination(
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
      ],
    );
  }

  void _showWIPItems(int projectId) {
    setState(() {
      expandedRowId = projectId;
      showWIPItems = true;
      _filteredWipItems = wipItemData
          .where((item) => item.wipId == projectId)
          .toList();
    });
  }

  Widget _buildWIPItemDetails() {
    if (expandedRowId == null) return Container();

    final project = wipData.firstWhere((p) => p.id == expandedRowId);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 768;

    return Container(
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'WIP Items: ${project.wipCode} - ${project.projectName}',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      showWIPItems = false;
                      expandedRowId = null;
                    });
                  },
                  tooltip: 'Back to Projects',
                ),
              ],
            ),
          ),
          // Project Summary
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
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
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildSummaryItem(
                      'Status',
                      project.status,
                      project.status == 'Progress'
                          ? Colors.blue
                          : project.status == 'Completed'
                          ? Colors.green
                          : Colors.grey,
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
          // WIP Items Table
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    'WIP Items (${_filteredWipItems.length})',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_filteredWipItems.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'No WIP items found for this project',
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                            fontSize: isSmallScreen ? 14 : 16,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
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
                          rows: _filteredWipItems.map((item) {
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
                                    item.costType,
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
                    ),
                  // Total Amount
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
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
        ],
      ),
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

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
