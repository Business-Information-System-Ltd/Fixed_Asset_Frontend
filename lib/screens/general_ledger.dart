import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GeneralLedger extends StatefulWidget {
  const GeneralLedger({super.key});

  @override
  State<GeneralLedger> createState() => _GeneralLedgerState();
}

class _GeneralLedgerState extends State<GeneralLedger> {
  final _formKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController _GLCodeController = TextEditingController();
  final TextEditingController _GLDateController = TextEditingController();
  final TextEditingController _SourceCodeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _debitAmountController = TextEditingController();
  final TextEditingController _creditAmountController = TextEditingController();
  final TextEditingController _AccountNameController = TextEditingController();

  //DropDown
  String? _selectedCurrency;
  String? _selectedSourceType;
  String? _selectedRefType;
  String? _selectedAccountCode;

  final List<String> _currencyOption = ['MMK', 'USD'];
  final List<String> _sourceTypeOption = ['WIP', 'Fixed Asset Register'];
  final List<String> _refTypeOption = ['Expense', 'Depreciation'];
  final List<String> _accountCodeOption = ['A_001', 'A_002', 'A_003'];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = _currencyOption.first;
    _selectedRefType = _refTypeOption.first;
    _selectedSourceType = _sourceTypeOption.first;
    _selectedAccountCode = _accountCodeOption.first;
    _GLDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _selectedDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _GLDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _GLCodeController.clear();
    _GLDateController.clear();
    _SourceCodeController.clear();
    _descriptionController.clear();
    _AccountNameController.clear();
    _debitAmountController.clear();
    _creditAmountController.clear();
    setState(() {
      _selectedCurrency = _currencyOption.first;
      _selectedRefType = _refTypeOption.first;
      _selectedSourceType = _sourceTypeOption.first;
      _selectedAccountCode = _accountCodeOption.first;
      _GLDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      print('GL Code: ${_GLCodeController.text}');
      print('GL Date: ${_GLDateController.text}');
      print('Source Code: ${_SourceCodeController.text}');
      print('Description: ${_descriptionController.text}');
      print('Debit Amount: ${_debitAmountController.text}');
      print('Credit Amount: ${_creditAmountController.text}');
      print('Account Name: ${_AccountNameController.text}');
      print('Currency: $_selectedCurrency');
      print('Ref Type: $_selectedRefType');
      print('Source Type: $_selectedSourceType');
      print('Account Code: $_selectedAccountCode');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form Saved Successfully'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  @override
  void dispose() {
    _GLCodeController.dispose();
    _GLDateController.dispose();
    _SourceCodeController.dispose();
    _descriptionController.dispose();
    _debitAmountController.dispose();
    _creditAmountController.dispose();
    _AccountNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("General Ledger Form"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700, minWidth: 500),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'General Ledger Form',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Row 1: GL Code and GL Date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GL Code:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _GLCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter GL Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter GL Code';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'GL Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _GLDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select GL date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                  ),
                                  onPressed: _selectedDate,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'GL Date is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Row 2: Source Type, Source Code, and Ref Type
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Source Type:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _selectedSourceType,
                              items: _sourceTypeOption
                                  .map(
                                    (type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSourceType = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select Source Type';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Source Code:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _SourceCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter Source Code',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Source Code';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ref Type:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _selectedRefType,
                              items: _refTypeOption
                                  .map(
                                    (type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRefType = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select Ref Type';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Description
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _descriptionController, // Fixed controller
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  // Debit Amount, Currency, Credit Amount
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Debit Amount:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _debitAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Debit Amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid amount';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Currency:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _selectedCurrency,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              items: _currencyOption.map((currency) {
                                return DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCurrency = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select currency';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Credit Amount:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _creditAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Credit Amount';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid amount';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Account Code and Account Name
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Account Code:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: _selectedAccountCode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              items: _accountCodeOption.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedAccountCode = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Select Account Code';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Account Name:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _AccountNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter Account Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter Account Name';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Save and Clear buttons
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _saveForm,
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
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: _clearForm,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
