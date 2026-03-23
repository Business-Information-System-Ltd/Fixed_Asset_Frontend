import 'dart:math';
// import 'dart:convert';
// import 'dart:typed_data';
import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/leaseScreen/leaseEntry.dart';
import 'package:fixed_asset_frontend/screens/search_function.dart';
import 'package:fixed_asset_frontend/screens/date_filter.dart';
import 'package:fixed_asset_frontend/screens/pagination.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// import 'package:intl/intl.dart';

class Leaselist extends StatefulWidget {
  const Leaselist({super.key});

  @override
  State<Leaselist> createState() => _LeaselistState();
}

class _LeaselistState extends State<Leaselist> {
  PlutoGridStateManager? _stateManager;
  PlutoGridStateManager? stateManager;
  int? selectedLeaseId;
  bool showLeaseDetails = false;
  List<PlutoColumn> _columns = [];
  List<PlutoRow> _rows = [];
  List<PlutoRow> _pagedRows = [];
  List<Lease> leasesLibData = [];
  List<Lease> _leases = [];

  List<Lease> _filteredLeases = [];
  DateTimeRange? _currentDateRange;
  String? _currentFilterType;
  String _searchQuery = '';
  int _currentPage = 1;
  int _rowsPerPage = 10;
  // LeaseSchedule? _currentSchedule;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _initializeData();
    _columns = _buildColumns();
    _loadLeases();
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

  double _calculateDiscountFactor(
    int period,
    double discountRate,
    String computation,
  ) {
    double rate = discountRate / 100.0;
    if (computation.toLowerCase().contains('month')) rate /= 12.0;
    if (computation.toLowerCase().contains('quarter')) rate /= 4.0;
    return 1 / pow(1 + rate, period);
  }

  Future<void> _loadLeases() async {
    try {
      final leases = await ApiService().fetchLease();
      setState(() {
        leasesLibData = leases;
        _leases = leases;
        _filteredLeases = leases;
        _rows = _buildRows(leasesLibData);
        _isLoading = false;
      });
      _updatePagedRows();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error fetching lease: $e');
    }
  }

  List<PresentValueEntry> generatePresentValue(Lease lease) {
    return lease.financial.amortizationSchedule.map((item) {
      double discountFactor = _calculateDiscountFactor(
        item.period,
        lease.financial.discountRate,
        lease.financial.computation,
      );

      double presentValue = item.payment * discountFactor;

      return PresentValueEntry(
        period: item.period,
        payment: item.payment,
        discountFactor: double.parse(discountFactor.toStringAsFixed(6)),
        presentValue: double.parse(presentValue.toStringAsFixed(2)),
      );
    }).toList();
  }

  void _showPresentValueDialog(Lease lease) {
    final pvEntries = generatePresentValue(lease);
    final totalPV = pvEntries.fold(
      0.0,
      (sum, entry) => sum + entry.presentValue,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: _buildPresentValueDialog(lease, pvEntries, totalPV),
        );
      },
    );
  }

  Widget _buildPresentValueDialog(
    Lease lease,
    List<PresentValueEntry> entries,
    double totalPV,
  ) {
    final isMonthly = lease.financial.computation.toLowerCase().contains(
      'month',
    );
    final isQuarterly = lease.financial.computation.toLowerCase().contains(
      'quarter',
    );
    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    final columnWidths = {
      'period': 100.0,
      'payment': 200.0,
      'discount_factor': 200.0,
      'present_value': 200.0,
    };

    final totalWidth = columnWidths.values.reduce((a, b) => a + b);

    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      constraints: BoxConstraints(
        maxWidth: 800,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(20),
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
                          'Present Value Calculation',
                          style: TextStyle(
                            fontSize: 20,
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
                      'Computation: ${lease.financial.computation} • Discount Rate: ${lease.financial.discountRate}%',
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

          const SizedBox(height: 20),

          // Table Container
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Table Header
                  Container(
                    height: 50,
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
                    child: SizedBox(
                      width: totalWidth,
                      child: Row(
                        children: [
                          // Period
                          Container(
                            width: columnWidths['period'],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // Payment
                          Container(
                            width: columnWidths['payment'],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Payment',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // Discount Factor
                          Container(
                            width: columnWidths['discount_factor'],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Discount Factor',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          // Present Value
                          Container(
                            width: columnWidths['present_value'],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Text(
                                'Present Value',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Table Body
                  Expanded(
                    child: SingleChildScrollView(
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
                              height: 45,
                              decoration: BoxDecoration(
                                color: isEven ? Colors.grey[50] : Colors.white,
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Period
                                  Container(
                                    width: columnWidths['period'],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
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
                                  // Payment
                                  Container(
                                    width: columnWidths['payment'],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
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
                                        '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(entry.payment)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Discount Factor
                                  Container(
                                    width: columnWidths['discount_factor'],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
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
                                        entry.discountFactor.toStringAsFixed(6),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.orange[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Present Value
                                  Container(
                                    width: columnWidths['present_value'],
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_getCurrencySymbol(lease.financial.currency)}${NumberFormat('#,##0.00').format(double.tryParse(lease.financial.presentValue.toString()) ?? 0.0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.purple[700],
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

                  // Total Present Value Footer
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      border: Border(top: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: SizedBox(
                      width: totalWidth,
                      child: Row(
                        children: [
                          // Empty cells
                          Container(
                            width: columnWidths['period'],
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                          ),
                          Container(
                            width: columnWidths['payment'],
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                          ),
                          Container(
                            width: columnWidths['discount_factor'],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Total PV:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: columnWidths['present_value'],
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(
                              child: Text(
                                '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(totalPV)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.picture_as_pdf, size: 18, color: Colors.white),
                label: const Text(
                  'Print PDF',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _printPresentValuePDF(lease, entries, totalPV),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.download, size: 18, color: Colors.white),
                label: const Text(
                  'Export CSV',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () =>
                    _exportPresentValueCSV(lease, entries, totalPV),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLeaseSchedule(Lease lease) {
    // final schedule = _generateLeaseSchedule(lease);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(10),
          child: _buildScheduleDialog(lease),
        );
      },
    );
  }

  Widget _buildScheduleDialog(Lease lease) {
    final entries = lease.financial.amortizationSchedule;
    final isMonthly = lease.financial.computation.toLowerCase().contains(
      'month',
    );

    final isQuarterly = lease.financial.computation.toLowerCase().contains(
      'quarter',
    );

    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    final totalPV = entries.fold(
      0.0,
      (sum, entry) => sum + entry.openingLeaseLiability,
    );

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
                  ],
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.calculate, size: 18, color: Colors.white),
                    label: const Text(
                      'Present Value',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => _showPresentValueDialog(lease),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.close, size: 28, color: Colors.grey[700]),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ],
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryTextItem(
                  'Lease Term',
                  '${lease.financial.leaseTerm} ${lease.financial.leasePeriod}',
                ),
                _buildSummaryTextItem(
                  'Payment Amount',
                  '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(lease.financial.paymentFrequency)} ${isMonthly
                      ? '/month'
                      : isQuarterly
                      ? '/quarter'
                      : '/year'}',
                ),
                _buildSummaryTextItem(
                  'Discount Rate',
                  '${lease.financial.discountRate}%',
                ),
                _buildSummaryTextItem(
                  'Total Periods',
                  '${entries.length} ${_getPeriodUnit(lease.financial.computation)}',
                ),
                _buildSummaryTextItem(
                  'Total Present Value',
                  '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(totalPV)}',
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
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
                                  'Interest\n(${lease.financial.discountRate}%)',
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
                                '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(entries[0].shortTermLease)}',
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
                                '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(entries[0].longTermLease)}',
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
                icon: Icon(Icons.picture_as_pdf, size: 20, color: Colors.white),
                label: Text('Print PDF', style: TextStyle(color: Colors.white)),
                onPressed: () => _printSchedulePDF(lease, entries, totalPV),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
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
                  'Export CSV',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _exportScheduleCSV(lease, entries, totalPV),
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

  Widget _buildSummaryTextItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }

  Future<void> _printSchedulePDF(
    Lease lease,
    List<AmortizationSchedule> entries,
    double totalPV,
  ) async {
    final doc = pw.Document();

    final isMonthly = lease.financial.computation.toLowerCase().contains(
      'month',
    );
    final isQuarterly = lease.financial.computation.toLowerCase().contains(
      'quarter',
    );
    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    final int rowsPerPage = 20;
    final currency = _getCurrencySymbol(lease.financial.currency);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Main Title
          pw.Center(
            child: pw.Text(
              'Lease Payment Schedule',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          // Two-column layout
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPdfInfoRow('Lease Code', lease.code),
                    _buildPdfInfoRow('Description', lease.description),
                    _buildPdfInfoRow(
                      'Term',
                      '${lease.financial.leaseTerm} ${lease.financial.leasePeriod}',
                    ),
                    _buildPdfInfoRow('Currency', lease.financial.currency),
                  ],
                ),
              ),
              pw.SizedBox(width: 40),
              // Right Column
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPdfInfoRow('Lease Type', lease.leaseType),
                    _buildPdfInfoRow('Lessor', lease.leasorName),
                    _buildPdfInfoRow(
                      'Discount Rate',
                      '${lease.financial.discountRate} %',
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: pw.BorderRadius.circular(4),
              color: PdfColors.grey100,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryBox(
                  'Payment Amount',
                  '${currency} ${NumberFormat('#,##0.00').format(lease.financial.paymentFrequency)} ${isMonthly
                      ? '/month'
                      : isQuarterly
                      ? '/quarter'
                      : '/year'}',
                ),
                _buildSummaryBox(
                  'Total Periods',
                  '${entries.length} ${_getPeriodUnit(lease.financial.computation)}',
                ),
                _buildSummaryBox(
                  'Total Present Value',
                  '${currency} ${NumberFormat('#,##0.00').format(totalPV)}',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Table Header (appears on every page)
          pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey),
                top: pw.BorderSide(color: PdfColors.grey),
              ),
            ),
            child: pw.Row(
              children: [
                _buildPdfHeaderCell(periodLabel, flex: 1),
                _buildPdfHeaderCell('Opening Lease\nLiability', flex: 2),
                _buildPdfHeaderCell(
                  'Interest\n(${lease.financial.discountRate}%)',
                  flex: 2,
                ),
                _buildPdfHeaderCell('Lease\nPayment', flex: 2),
                _buildPdfHeaderCell('Closing Lease\nLiability', flex: 2),
                _buildPdfHeaderCell('Opening\nROU Asset', flex: 2),
                _buildPdfHeaderCell('ROU\nDepreciation', flex: 2),
                _buildPdfHeaderCell('Closing\nROU Asset', flex: 2),
              ],
            ),
          ),

          // Table Body - Split into pages
          ..._buildPdfTablePages(
            entries: entries,
            rowsPerPage: rowsPerPage,
            lease: lease,
          ),

          // First Entry Summary (appears on last page only)
          if (entries.isNotEmpty)
            pw.Column(
              children: [
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.green),
                    borderRadius: pw.BorderRadius.circular(4),
                    color: PdfColors.green50,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'For $periodLabel 1 Entry',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green700,
                          fontSize: 14,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Row(
                              children: [
                                pw.Text(
                                  'Short Term Lease: ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  '${currency} ${NumberFormat('#,##0.00').format(entries[0].shortTermLease)}',
                                ),
                              ],
                            ),
                          ),
                          pw.Container(
                            width: 1,
                            height: 20,
                            color: PdfColors.green300,
                          ),
                          pw.SizedBox(width: 20),
                          pw.Expanded(
                            child: pw.Row(
                              children: [
                                pw.Text(
                                  'Long Term Lease: ',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  '${currency} ${NumberFormat('#,##0.00').format(entries[0].longTermLease)}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  Future<void> _printPresentValuePDF(
    Lease lease,
    List<PresentValueEntry> entries,
    double totalPV,
  ) async {
    final doc = pw.Document();

    final isMonthly = lease.financial.computation.toLowerCase().contains(
      'month',
    );
    final isQuarterly = lease.financial.computation.toLowerCase().contains(
      'quarter',
    );
    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    final int rowsPerPage = 25;
    final currency = _getCurrencySymbol(lease.financial.currency);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // Main Title
          pw.Center(
            child: pw.Text(
              'Present Value Calculation',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),

          // Two-column layout
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Left Column
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPdfInfoRow('Lease Code', lease.code),
                    _buildPdfInfoRow('Description', lease.description),
                    _buildPdfInfoRow(
                      'Term',
                      '${lease.financial.leaseTerm} ${lease.financial.leasePeriod}',
                    ),
                    _buildPdfInfoRow('Currency', lease.financial.currency),
                  ],
                ),
              ),
              pw.SizedBox(width: 40),
              // Right Column
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildPdfInfoRow('Lease Type', lease.leaseType),
                    _buildPdfInfoRow('Lessor', lease.leasorName),
                    _buildPdfInfoRow(
                      'Discount Rate',
                      '${lease.financial.discountRate} %',
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Summary Section
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: pw.BorderRadius.circular(4),
              color: PdfColors.grey100,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryBox(
                  'Payment Amount',
                  '${currency} ${NumberFormat('#,##0.00').format(lease.financial.paymentFrequency)} ${isMonthly
                      ? '/month'
                      : isQuarterly
                      ? '/quarter'
                      : '/year'}',
                ),
                _buildSummaryBox(
                  'Total Periods',
                  '${entries.length} ${_getPeriodUnit(lease.financial.computation)}',
                ),
                _buildSummaryBox(
                  'Total Present Value',
                  '${currency} ${NumberFormat('#,##0.00').format(totalPV)}',
                ),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Table Header (appears on every page)
          pw.Container(
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey),
                top: pw.BorderSide(color: PdfColors.grey),
              ),
            ),
            child: pw.Row(
              children: [
                _buildPdfHeaderCell(periodLabel, flex: 1),
                _buildPdfHeaderCell('Payment', flex: 2),
                _buildPdfHeaderCell('Discount Factor', flex: 2),
                _buildPdfHeaderCell('Present Value', flex: 2),
              ],
            ),
          ),

          // Table Body - Split into pages
          ..._buildPdfPresentValuePages(
            entries: entries,
            rowsPerPage: rowsPerPage,
            lease: lease,
          ),

          // Total and Formula Note
          pw.Column(
            children: [
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue50,
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Present Value:',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    pw.Text(
                      '${currency} ${NumberFormat('#,##0.00').format(totalPV)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: PdfColors.blue700,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 20),

              // Formula Note
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                  borderRadius: pw.BorderRadius.circular(4),
                  color: PdfColors.grey50,
                ),
                child: pw.Text(
                  'Note: Present Value is calculated using the formula: PV = Payment × (1/(1+r)^n) where r is the periodic discount rate',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
          ),
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  pw.Widget _buildPdfInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Container(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
          ),
          pw.Text(value, style: pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  pw.Widget _buildSummaryBox(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue700,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfHeaderCell(String text, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border(right: pw.BorderSide(color: PdfColors.grey300)),
        ),
        child: pw.Text(
          text,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 10,
            color: PdfColors.blue900,
          ),
        ),
      ),
    );
  }

  pw.Widget _buildPdfCell(
    String text, {
    int flex = 1,
    pw.Alignment alignment = pw.Alignment.centerRight,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        padding: const pw.EdgeInsets.all(6),
        decoration: pw.BoxDecoration(
          border: pw.Border(
            right: pw.BorderSide(color: PdfColors.grey300),
            bottom: pw.BorderSide(color: PdfColors.grey300),
          ),
        ),
        child: pw.Container(
          alignment: alignment,
          child: pw.Text(
            text,
            style: pw.TextStyle(fontSize: 9),
            textAlign: alignment == pw.Alignment.centerRight
                ? pw.TextAlign.right
                : pw.TextAlign.center,
          ),
        ),
      ),
    );
  }

  List<pw.Widget> _buildPdfTablePages({
    required List<AmortizationSchedule> entries,
    required int rowsPerPage,
    required Lease lease,
  }) {
    List<pw.Widget> pages = [];

    for (int i = 0; i < entries.length; i += rowsPerPage) {
      final end = (i + rowsPerPage) > entries.length
          ? entries.length
          : i + rowsPerPage;
      final pageEntries = entries.sublist(i, end);

      pages.add(
        pw.Column(
          children: pageEntries.map((entry) {
            final isEven = pageEntries.indexOf(entry) % 2 == 0;
            return pw.Container(
              color: isEven ? PdfColors.grey50 : null,
              child: pw.Row(
                children: [
                  _buildPdfCell(
                    entry.period.toString(),
                    flex: 1,
                    alignment: pw.Alignment.center,
                  ),
                  _buildPdfCell(
                    NumberFormat(
                      '#,##0.00',
                    ).format(entry.openingLeaseLiability),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    NumberFormat('#,##0.00').format(entry.interest),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    NumberFormat('#,##0.00').format(entry.leasePayment),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    NumberFormat(
                      '#,##0.00',
                    ).format(entry.closingLeaseLiability),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    NumberFormat('#,##0.00').format(entry.openingROUAsset),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    NumberFormat('#,##0.00').format(entry.rOUDepreciation),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    NumberFormat('#,##0.00').format(entry.closingROUAsset),
                    flex: 2,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    return pages;
  }

  List<pw.Widget> _buildPdfPresentValuePages({
    required List<PresentValueEntry> entries,
    required int rowsPerPage,
    required Lease lease,
  }) {
    List<pw.Widget> pages = [];
    final currency = _getCurrencySymbol(lease.financial.currency);

    for (int i = 0; i < entries.length; i += rowsPerPage) {
      final end = (i + rowsPerPage) > entries.length
          ? entries.length
          : i + rowsPerPage;
      final pageEntries = entries.sublist(i, end);

      pages.add(
        pw.Column(
          children: pageEntries.map((entry) {
            final isEven = pageEntries.indexOf(entry) % 2 == 0;
            return pw.Container(
              color: isEven ? PdfColors.grey50 : null,
              child: pw.Row(
                children: [
                  _buildPdfCell(
                    entry.period.toString(),
                    flex: 1,
                    alignment: pw.Alignment.center,
                  ),
                  _buildPdfCell(
                    '${currency} ${NumberFormat('#,##0.00').format(entry.payment)}',
                    flex: 2,
                  ),
                  _buildPdfCell(
                    entry.discountFactor.toStringAsFixed(6),
                    flex: 2,
                  ),
                  _buildPdfCell(
                    '${currency} ${NumberFormat('#,##0.00').format(entry.presentValue)}',
                    flex: 2,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    }

    return pages;
  }

  Future<void> _exportScheduleCSV(
    Lease lease,
    List<AmortizationSchedule> entries,
    double totalPV,
  ) async {
    final isMonthly = lease.financial.computation.toLowerCase().contains(
      'month',
    );
    final isQuarterly = lease.financial.computation.toLowerCase().contains(
      'quarter',
    );
    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    List<List<String>> rows = [
      ['Lease Payment Schedule'],
      ['Lease Code', lease.code],
      ['Lease Type', lease.leaseType],
      ['Description', lease.description],
      ['Leasor Name', lease.leasorName],
      [
        'Lease Term',
        '${lease.financial.leaseTerm} ${lease.financial.leasePeriod}',
      ],
      [
        'Payment Amount',
        '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(lease.financial.paymentFrequency)} ${isMonthly
            ? '/month'
            : isQuarterly
            ? '/quarter'
            : '/year'}',
      ],
      ['Discount Rate', '${lease.financial.discountRate}%'],
      [
        'Total Periods',
        '${entries.length} ${_getPeriodUnit(lease.financial.computation)}',
      ],
      [
        'Total Present Value',
        '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(totalPV)}',
      ],
      [''],
      [
        periodLabel,
        'Opening Lease Liability',
        'Interest',
        'Lease Payment',
        'Closing Lease Liability',
        'Opening ROU Asset',
        'ROU Depreciation',
        'Closing ROU Asset',
        'Short Term Lease',
        'Long Term Lease',
      ],
    ];

    for (var entry in entries) {
      rows.add([
        entry.period.toString(),
        entry.openingLeaseLiability.toStringAsFixed(2),
        entry.interest.toStringAsFixed(2),
        entry.leasePayment.toStringAsFixed(2),
        entry.closingLeaseLiability.toStringAsFixed(2),
        entry.openingROUAsset.toStringAsFixed(2),
        entry.rOUDepreciation.toStringAsFixed(2),
        entry.closingROUAsset.toStringAsFixed(2),
        entry.shortTermLease.toStringAsFixed(2),
        entry.longTermLease.toStringAsFixed(2),
      ]);
    }

    if (entries.isNotEmpty) {
      rows.add(['']);
      rows.add(['For $periodLabel 1 Entry']);
      rows.add([
        'Short Term Lease',
        '${_getCurrencySymbol(lease.financial.currency)} ${entries[0].shortTermLease.toStringAsFixed(2)}',
      ]);
      rows.add([
        'Long Term Lease',
        '${_getCurrencySymbol(lease.financial.currency)} ${entries[0].longTermLease.toStringAsFixed(2)}',
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/lease_schedule_${lease.code}_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'Lease Schedule Export');
  }

  Future<void> _exportPresentValueCSV(
    Lease lease,
    List<PresentValueEntry> entries,
    double totalPV,
  ) async {
    final isMonthly = lease.financial.computation.toLowerCase().contains(
      'month',
    );
    final isQuarterly = lease.financial.computation.toLowerCase().contains(
      'quarter',
    );
    final periodLabel = isMonthly
        ? 'Month'
        : isQuarterly
        ? 'Quarter'
        : 'Year';

    List<List<String>> rows = [
      ['Present Value Calculation'],
      ['Lease Code', lease.code],
      ['Lease Type', lease.leaseType],
      ['Description', lease.description],
      ['Leasor Name', lease.leasorName],
      [
        'Lease Term',
        '${lease.financial.leaseTerm} ${lease.financial.leasePeriod}',
      ],
      [
        'Payment Amount',
        '${_getCurrencySymbol(lease.financial.currency)} ${NumberFormat('#,##0.00').format(lease.financial.paymentFrequency)} ${isMonthly
            ? '/month'
            : isQuarterly
            ? '/quarter'
            : '/year'}',
      ],
      ['Discount Rate', '${lease.financial.discountRate}%'],
      [
        'Total Periods',
        '${entries.length} ${_getPeriodUnit(lease.financial.computation)}',
      ],
      [''],
      [periodLabel, 'Payment', 'Discount Factor', 'Present Value'],
    ];

    for (var entry in entries) {
      rows.add([
        entry.period.toString(),
        entry.payment.toStringAsFixed(2),
        entry.discountFactor.toStringAsFixed(6),
        entry.presentValue.toStringAsFixed(2),
      ]);
    }

    rows.add(['']);
    rows.add([
      'Total Present Value',
      '${_getCurrencySymbol(lease.financial.currency)} ${totalPV.toStringAsFixed(2)}',
    ]);

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/present_value_${lease.code}_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);

    await Share.shareXFiles([XFile(path)], text: 'Present Value Export');
  }

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
    print('Applying filter with query: $_searchQuery');
    print('Date range: $_currentDateRange');

    List<Lease> filtered = leasesLibData;
    print('Initial lease count: ${filtered.length}');

    // Date filter
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
        DateTime leaseStart;
        try {
          leaseStart = DateTime.parse(lease.financial.startDate);
        } catch (_) {
          leaseStart = lease.getContractDate();
        }

        final leaseDate = DateTime(
          leaseStart.year,
          leaseStart.month,
          leaseStart.day,
        );

        return leaseDate.isAtSameMomentAs(startDate) ||
            (leaseDate.isAfter(startDate) && leaseDate.isBefore(endDate));
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((lease) {
        final match =
            lease.code.toLowerCase().contains(query) ||
            lease.leaseType.toLowerCase().contains(query) ||
            lease.description.toLowerCase().contains(query) ||
            lease.leasorName.toLowerCase().contains(query) ||
            lease.status.toLowerCase().contains(query);

        if (!match) print('Lease ${lease.id} filtered out by search');
        return match;
      }).toList();
    }

    print('Filtered lease count: ${filtered.length}');

    setState(() {
      _filteredLeases = filtered;
      _rows = _buildRows(_filteredLeases);
      _currentPage = 1;
    });

    if (_stateManager != null) {
      _stateManager!.refRows.clear();
      _stateManager!.refRows.addAll(_rows);
      _stateManager!.setPage(1);
      _stateManager!.notifyListeners();
    }
  }

  void _updatePagedRows() {
    if (_stateManager == null) return;
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
          type: PlutoColumnType.date(format: 'yyyy-MM-dd'),
          width: isSmallScreen ? 100 : 150,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Start Date',
          field: 'start_date',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.date(format: 'yyyy-MM-dd'),
          width: isSmallScreen ? 90 : 110,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'End Date',
          field: 'end_date',
          readOnly: true,
          enableEditingMode: false,
          type: PlutoColumnType.date(format: 'yyyy-MM-dd'),
          width: isSmallScreen ? 90 : 110,
        ),
      if (!isSmallScreen)
        PlutoColumn(
          title: 'Lease Term',
          field: 'lease_term',
          readOnly: true,
          enableEditingMode: false,
          textAlign: PlutoColumnTextAlign.right,
          type: PlutoColumnType.text(),
          width: isSmallScreen ? 100 : 150,
          renderer: (rendererContext) {
            final termRaw = rendererContext.row.cells['lease_term']?.value;
            final periodRaw = rendererContext.row.cells['lease_period']?.value;

            int termValue = 0;
            if (termRaw is num) {
              termValue = termRaw.toInt();
            } else {
              termValue = int.tryParse(termRaw.toString()) ?? 0;
            }

            String periodText = "";
            String p = periodRaw.toString();

            switch (p) {
              case "0":
                periodText = "Year(s)";
                break;
              case "1":
                periodText = "Month(s)";
                break;
              case "2":
                periodText = "Day(s)";
                break;
              default:
                periodText = p.isNotEmpty ? "${p}(s)" : "";
            }

            return Text(
              '$termValue $periodText',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                fontSize: isSmallScreen ? 12 : 14,
              ),
            );
          },
        ),
      PlutoColumn(
        title: 'Contract Amount',
        field: 'contract_amount',
        readOnly: true,
        enableEditingMode: false,
        type: PlutoColumnType.number(),
        width: isSmallScreen ? 140 : 180,
        textAlign: PlutoColumnTextAlign.right,
        titleTextAlign: PlutoColumnTextAlign.right,
        renderer: (rendererContext) {
          final row = rendererContext.row;

          final amount = row.cells['contract_amount']?.value ?? 0.0;
          final currency = row.cells['currency']?.value ?? '';

          final formattedAmount = NumberFormat('#,##0.00').format(amount);

          return Text(
            '$formattedAmount $currency',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
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
              break;
            case 'completed':
              color = Colors.blue;
              break;
            case 'amendment':
              color = Colors.orange;
              break;
            case 'cancelled':
              color = Colors.red;
              break;
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
        width: isSmallScreen ? 180 : 200,
        renderer: (rendererContext) {
          final row = rendererContext.row;
          final leaseCode = row.cells['code']!.value as String;
          final lease = leasesLibData.firstWhere((l) => l.code == leaseCode);

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
              const SizedBox(width: 4),

              // View Schedule Button
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
              const SizedBox(width: 4),

              // Present Value Button
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.calculate,
                    size: 18,
                    color: const Color.fromARGB(255, 50, 107, 101),
                  ),
                  onPressed: () {
                    _showPresentValueDialog(lease);
                  },
                  tooltip: 'View Present Value',
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

  List<PlutoRow> _buildRows(List<Lease> leases) {
    print('Building rows for ${leases.length} leases');

    return leases.map((lease) {
      print('Lease ID: ${lease.id}, Code: ${lease.code}');
      print('Contract Date: ${lease.contractDate}');

      DateTime contractDate;
      DateTime startDate;
      DateTime endDate;

      try {
        contractDate = lease.getContractDate();
      } catch (e) {
        print('Error parsing contractDate for lease ${lease.id}: $e');
        contractDate = DateTime.now();
      }

      try {
        startDate = lease.getStartDate();
      } catch (e) {
        print('Error parsing startDate for lease ${lease.id}: $e');
        startDate = DateTime.now();
      }

      try {
        endDate = lease.getEndDate();
      } catch (e) {
        print('Error parsing endDate for lease ${lease.id}: $e');
        endDate = DateTime.now();
      }

      return PlutoRow(
        cells: {
          'id': PlutoCell(value: lease.id),
          'code': PlutoCell(value: lease.code),
          'lease_type': PlutoCell(value: lease.leaseType),
          'description': PlutoCell(value: lease.description),
          'leasor_name': PlutoCell(value: lease.leasorName),

          'contract_date': PlutoCell(value: lease.getContractDate()),
          'start_date': PlutoCell(value: lease.getStartDate()),
          'end_date': PlutoCell(value: lease.getEndDate()),

          'lease_term': PlutoCell(value: lease.financial.leaseTerm.toString()),
          'lease_period': PlutoCell(value: lease.financial.leasePeriod),
          'contract_amount': PlutoCell(value: lease.financial.contractAmount),
          'currency': PlutoCell(value: lease.financial.currency),
          'status': PlutoCell(value: lease.status.toLowerCase()),
          'actions': PlutoCell(value: ''),
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
        padding: const EdgeInsets.all(8),
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
                padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LeaseEntryForm(),
                            ),
                          ).then((_) {
                            _loadLeases();
                          });
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
            const SizedBox(height: 12),

            // Main Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!showLeaseDetails)
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(child: _buildLeaseTable()),

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: _buildPagination(),
                          ),
                        ],
                      ),
                    ),

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
    print("Filtered Leases Count: ${_filteredLeases.length}");
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
      (sum, lease) => sum + lease.financial.contractAmount ?? 0.0,
    );
    final avgContractValue = totalLeases > 0
        ? totalContractValue / totalLeases
        : 0.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatCard(
            'Total Leases',
            totalLeases.toString(),
            Icons.assignment,
            Colors.blue[700]!,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Active Leases',
            activeLeases.toString(),
            Icons.check_circle,
            Colors.green[700]!,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Completed',
            completedLeases.toString(),
            Icons.done_all,
            Colors.blue[700]!,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Amendment',
            amendmentLeases.toString(),
            Icons.change_circle,
            Colors.orange[700]!,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Cancelled',
            cancelLeases.toString(),
            Icons.cancel,
            Colors.red[700]!,
          ),
        ],
      ),
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
      child: Container(
        width: 200,
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
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text(
                      'Loading leases...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            : PlutoGrid(
                columns: _columns,
                rows: _rows,
                // onLoaded: (event) => _stateManager = event.stateManager,
                onLoaded: (event) {
                  _stateManager = event.stateManager;
                  _updatePagedRows();
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

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty || dateStr == "null") {
      return DateTime(1970, 1, 1);
    }

    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      print("Invalid date: $dateStr");
      return DateTime(1970, 1, 1);
    }
  }

  String _formatLeaseTerm(double term, String period) {
    int termValue = term.toInt();
    String periodText;

    switch (period.toLowerCase()) {
      case "year":
        periodText = "Year(s)";
        break;
      case "month":
        periodText = "Month(s)";
        break;
      case "day":
        periodText = "Day(s)";
        break;
      default:
        periodText = period;
    }

    return "$termValue $periodText";
  }

  Widget _buildLeaseDetails() {
    if (selectedLeaseId == null) return Container();

    final lease = leasesLibData.firstWhere((l) => l.id == selectedLeaseId);

    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF8F9FD),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopRing(lease),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildGlassCard('Basic Information', [
                        _buildInfoRow('Lease Type:', lease.leaseType),
                        _buildInfoRow('Leasor Name:', lease.leasorName),
                        _buildInfoRow('Description:', lease.description),
                        _buildInfoRow('Reason:', lease.financial.reason),
                      ]),
                      const SizedBox(height: 10),
                      _buildGlassCard('Date Information', [
                        _buildInfoRow(
                          'Contract Date:',
                          DateFormat(
                            'yyyy-MM-dd',
                          ).format(lease.getContractDate()),
                        ),
                        _buildInfoRow(
                          'Start Date:',
                          DateFormat('yyyy-MM-dd').format(lease.getStartDate()),
                        ),
                        _buildInfoRow(
                          'End Date:',
                          DateFormat('yyyy-MM-dd').format(lease.getEndDate()),
                        ),

                        _buildInfoRow(
                          'Lease Term:',
                          _formatLeaseTerm(
                            lease.financial.leaseTerm,
                            lease.financial.leasePeriod,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                Expanded(
                  child: Column(
                    children: [
                      _buildGlassCard('Contract Details', [
                        _buildInfoRow(
                          'Contract Amount:',
                          _formatCurrency(
                            lease.financial.contractAmount,
                            lease.financial.currency,
                          ),
                        ),
                        _buildInfoRow(
                          'Deposit:',
                          _formatCurrency(
                            lease.financial.deposit,
                            lease.financial.currency,
                          ),
                        ),
                        _buildInfoRow(
                          'Present Value:',
                          _formatCurrency(
                            lease.financial.presentValue,
                            lease.financial.currency,
                          ),
                        ),
                        _buildInfoRow(
                          'Down Payment:',
                          _formatCurrency(
                            lease.financial.downpayment,
                            lease.financial.currency,
                          ),
                        ),
                        _buildInfoRow(
                          'Other Cost:',
                          _formatCurrency(
                            lease.financial.otherCost,
                            lease.financial.currency,
                          ),
                        ),
                        _buildInfoRow(
                          'Dismantling Cost:',
                          _formatCurrency(
                            lease.financial.dismantlingCost,
                            lease.financial.currency,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      _buildGlassCard('Currency Information', [
                        _buildInfoRow(
                          'Transaction Currency:',
                          lease.financial.currency,
                        ),
                        _buildInfoRow(
                          'Home Currency:',
                          lease.financial.homeCurrency,
                        ),
                        _buildInfoRow(
                          'Exchange Rate:',
                          lease.financial.exchangeRate.toStringAsFixed(4),
                        ),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    children: [
                      _buildGlassCard('Payment Details', [
                        _buildInfoRow(
                          'Payment Amount:',
                          _formatCurrency(
                            lease.financial.paymentFrequency,
                            lease.financial.currency,
                          ),
                        ),
                        _buildInfoRow(
                          'Payment Period:',
                          lease.financial.paymentPeriod,
                        ),
                        _buildInfoRow(
                          'Discount Rate:',
                          '${lease.financial.discountRate}%',
                        ),
                        _buildInfoRow(
                          'Computation Method:',
                          lease.financial.computation,
                        ),
                      ]),
                      const SizedBox(height: 10),
                      if (lease.financial.changingDate != null &&
                          lease.financial.changingDate != "1970-01-01" &&
                          lease.financial.changingAmount > 0) ...[
                        _buildGlassCard('Change Information', [
                          _buildInfoRow(
                            'Changing Date:',
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(_parseDate(lease.financial.changingDate)),
                          ),
                          _buildInfoRow(
                            'Changing Amount:',
                            _formatCurrency(
                              lease.financial.changingAmount,
                              lease.financial.currency,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 10),
                      ],

                      _buildGlassCard('Actions', [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildActionBtn(
                              'Payment Schedule',
                              Icons.access_time_filled,
                              Colors.blue[700]!,
                              () => _showLeaseSchedule(lease),
                            ),

                            const SizedBox(width: 12),

                            _buildActionBtn(
                              'Present Value',
                              Icons.calculate,
                              Colors.blue[700]!,
                              () => _showPresentValueDialog(lease),
                            ),
                          ],
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            _buildSummarySection(lease),

            // const SizedBox(height: 20),
            // OutlinedButton(
            //   onPressed: () => setState(() => showLeaseDetails = false),
            //   child: const Text("Close Details"),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRing(dynamic lease) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.all(8)),
        Text(
          lease.code,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 21, 101, 192),
          ),
        ),
        const SizedBox(width: 16),
        _buildStatusBadge(lease.status),
        const Spacer(),

        IconButton(
          onPressed: () => setState(() => showLeaseDetails = false),
          icon: const Icon(Icons.close, color: Color.fromARGB(255, 69, 68, 68)),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    final s = status.toLowerCase();

    Color bgColor;
    switch (s) {
      case 'active':
        bgColor = const Color(0xFFE8F5E9);
        break;
      case 'completed':
        bgColor = const Color(0xFFE3F2FD);
        break;
      case 'amendment':
        bgColor = const Color(0xFFFFF3E0);
        break;
      case 'cancelled':
        bgColor = const Color(0xFFFFEBEE);
        break;
      default:
        bgColor = Colors.grey[100]!;
    }

    Color mainColor;
    switch (s) {
      case 'active':
        mainColor = Colors.green[700]!;
        break;
      case 'completed':
        mainColor = Colors.blue[700]!;
        break;
      case 'amendment':
        mainColor = Colors.orange[700]!;
        break;
      case 'cancelled':
        mainColor = Colors.red[700]!;
        break;
      default:
        mainColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: mainColor.withOpacity(0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: mainColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
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
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummarySection(dynamic lease) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Contract Value:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
          Text(
            _formatCurrency(
              lease.financial.contractAmount,
              lease.financial.currency,
            ),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,

        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    final formatter = NumberFormat('#,##0.00');
    return ' ${formatter.format(amount)} ${getCurrencySymbol(currency)}';
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

  String getCurrencySymbol(String currency) {
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
