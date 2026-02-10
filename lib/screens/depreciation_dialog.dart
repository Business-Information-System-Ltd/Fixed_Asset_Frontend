import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:flutter/material.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:intl/intl.dart';

class DepreciationDialog extends StatefulWidget {
  final FixedAssets asset;
  final Function(bool) onDepreciated;

  const DepreciationDialog({
    Key? key,
    required this.asset,
    required this.onDepreciated,
  }) : super(key: key);

  @override
  _DepreciationDialogState createState() => _DepreciationDialogState();
}

class _DepreciationDialogState extends State<DepreciationDialog> {
  final ApiService _depreciationService = ApiService();
  bool _isLoading = false;
  bool _postToJournal = true;
  String _journalDescription = '';
  Map<String, dynamic>? _depreciationData;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _checkDepreciation();
    _journalDescription =
        'Depreciation for ${widget.asset.fixedAssetCode} - '
        '${DateFormat('MMMM yyyy').format(DateTime.now())}';
  }

  Future<void> _checkDepreciation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _depreciationService.calculateDepreciation(
        widget.asset.id,
        _postToJournal,
      );

      setState(() {
        _depreciationData = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _executeDepreciation() async {
    if (_depreciationData == null ||
        _depreciationData!['can_depreciate'] != true) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _depreciationService.executeDepreciation(
        assetId: widget.asset.id,
        postToJournal: _postToJournal,
        journalDescription: _journalDescription,
      );

      if (result['success'] == true) {
        setState(() {
          _successMessage =
              '✅ Depreciation completed successfully!\n\n'
              'Amount: ${widget.asset.homeCurrency} ${result['depreciation_amount']?.toStringAsFixed(2)}\n'
              'New NBV: ${widget.asset.homeCurrency} ${result['new_net_book_value']?.toStringAsFixed(2)}';
          _isLoading = false;
        });

        // Notify parent
        widget.onDepreciated(true);

        // Auto-close after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        });
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to execute depreciation';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Widget _buildAssetInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.asset.fixedAssetCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: widget.asset.assetStatus == 'Ready to Use'
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: widget.asset.assetStatus == 'Ready to Use'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  child: Text(
                    widget.asset.assetStatus,
                    style: TextStyle(
                      color: widget.asset.assetStatus == 'Ready to Use'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.asset.assetName,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text('Method: ${widget.asset.depreciationMethod}'),
                  backgroundColor: Colors.blue[50],
                ),
                Chip(
                  label: Text('Compute: ${widget.asset.computation}'),
                  backgroundColor: Colors.orange[50],
                ),
                Chip(
                  label: Text(
                    'Life: ${widget.asset.usefulLife} ${widget.asset.period}',
                  ),
                  backgroundColor: Colors.purple[50],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current NBV',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      '${widget.asset.homeCurrency} ${widget.asset.currentNbv.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      '${widget.asset.homeCurrency} ${widget.asset.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepreciationSummary() {
    if (_isLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Calculating depreciation...'),
          ],
        ),
      );
    }

    if (_depreciationData == null) {
      return Container();
    }

    if (_depreciationData!['can_depreciate'] != true) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 48),
                const SizedBox(height: 16),
                Text(
                  _depreciationData?['message'] ??
                      'Cannot depreciate at this time',
                  style: const TextStyle(fontSize: 16, color: Colors.orange),
                  textAlign: TextAlign.center,
                ),
                if (_depreciationData?['next_depreciation_date'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Next depreciation: ${_depreciationData!['next_depreciation_date']}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    final depreciationAmount = _depreciationData?['depreciation_amount'] ?? 0;
    final newNbv = _depreciationData?['new_net_book_value'] ?? 0;
    final currentNbv =
        _depreciationData?['current_nbv'] ?? widget.asset.currentNbv;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Depreciation Calculation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Period',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(DateTime.now()),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Depreciation Amount',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      '${widget.asset.homeCurrency} ${depreciationAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current NBV',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.asset.homeCurrency} ${currentNbv.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.blue, size: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'New NBV',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.asset.homeCurrency} ${newNbv.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Method: ${_depreciationData?['depreciation_method']} • '
              'Computation: ${_depreciationData?['computation']}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalOptions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Journal Entry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Post to General Ledger'),
              subtitle: const Text(
                'Create journal entry for this depreciation',
              ),
              value: _postToJournal,
              onChanged: (value) {
                setState(() {
                  _postToJournal = value;
                });
                _checkDepreciation();
              },
              activeColor: Colors.blue,
              contentPadding: EdgeInsets.zero,
            ),
            if (_postToJournal)
              Column(
                children: [
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Journal Description',
                      border: OutlineInputBorder(),
                      hintText: 'Enter journal entry description',
                      contentPadding: EdgeInsets.all(12),
                    ),
                    maxLines: 2,
                    initialValue: _journalDescription,
                    onChanged: (value) {
                      _journalDescription = value;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Debit: ${widget.asset.expenseAccount}\n'
                          'Credit: ${widget.asset.depreciationAccount}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Depreciate Fixed Asset',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 24),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Error message
                if (_errorMessage != null && !_isLoading)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200] ?? Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Success message
                if (_successMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green[200] ?? Colors.green,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (!_isLoading && _successMessage == null) ...[
                  // Asset Info
                  _buildAssetInfo(),
                  const SizedBox(height: 20),

                  // Depreciation Summary
                  _buildDepreciationSummary(),
                  const SizedBox(height: 20),

                  // Journal Options (only if can depreciate)
                  if (_depreciationData?['can_depreciate'] == true)
                    _buildJournalOptions(),
                ],

                const SizedBox(height: 24),

                // Action Buttons
                if (_depreciationData?['can_depreciate'] == true &&
                    _successMessage == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _executeDepreciation,
                        icon: const Icon(Icons.calculate, size: 20),
                        label: const Text('Depreciate Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (_successMessage == null)
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
