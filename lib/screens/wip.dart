import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WipForm extends StatefulWidget {
  const WipForm({super.key});

  @override
  State<WipForm> createState() => _WipFormState();
}

class _WipFormState extends State<WipForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _wipCodeController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  // DropDown
  String? _selectedCurrency;
  String? _selectedGLCode;

  // Checkbox state
  bool _isFromGL = false;

  final List<String> _currencyOptions = ['MMK', 'USD'];
  final List<String> _GLCodeOptions = ['1001', '1002', '1003', '1004'];

  List<Wip> wip_data = [];
  double _calculatedTotal = 0.0;
  bool _isCalculatingTotal = false;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = _currencyOptions.first;
    _selectedGLCode = _GLCodeOptions.first;
    _fetchData();
  }

  void _fetchData() async {
    try {
      List<Wip> wipDetails = await ApiService().fetchWipData();
      setState(() {
        wip_data = wipDetails;
      });
    } catch (e) {
      print('Fail to load wip data : $e');
    }
  }

  // Calculate total for existing project
  Future<void> _calculateAndDisplayTotal() async {
    if (_wipCodeController.text.isEmpty) {
      setState(() {
        _calculatedTotal = 0.0;
        _totalAmountController.text = '0.00';
      });
      return;
    }

    setState(() {
      _isCalculatingTotal = true;
    });

    try {
      // Find the project by wipCode
      final project = wip_data.firstWhere(
        (p) => p.wipCode == _wipCodeController.text,
        orElse: () => Wip(
          id: 0,
          wipCode: '',
          projectName: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          description: '',
          status: '',
          totalAmount: 0.0,
          currency: 'MMK',
        ),
      );

      if (project.id > 0) {
        // Calculate total from API
        final total = await ApiService().calculateWipTotalAmount(project.id);
        setState(() {
          _calculatedTotal = total;
          _totalAmountController.text = total.toStringAsFixed(2);
        });
        print('Calculated total for ${project.wipCode}: $total');
      } else {
        setState(() {
          _calculatedTotal = 0.0;
          _totalAmountController.text = '0.00';
        });
      }
    } catch (e) {
      print('Error calculating WIP total: $e');
      setState(() {
        _calculatedTotal = 0.0;
        _totalAmountController.text = '0.00';
      });
    } finally {
      setState(() {
        _isCalculatingTotal = false;
      });
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _wipCodeController.clear();
    _projectNameController.clear();
    _descriptionController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _totalAmountController.clear();
    setState(() {
      _selectedCurrency = _currencyOptions.first;
      _selectedGLCode = _GLCodeOptions.first;
      _isFromGL = false;
      _calculatedTotal = 0.0;
    });
  }

  Future<int> _generateWipId() async {
    List<Wip> existingWips = await ApiService().fetchWipData();
    if (existingWips.isEmpty) {
      return 1;
    }
    int maxId = existingWips.map((b) => b.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 10),
              Text('Saving WIP data...'),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 5),
        ),
      );

      try {
        int nextID = await _generateWipId();
        Wip newWip = Wip(
          id: nextID,
          wipCode: _wipCodeController.text,
          projectName: _projectNameController.text,
          startDate: DateFormat('yyyy-MM-dd').parse(_startDateController.text),
          endDate: DateFormat('yyyy-MM-dd').parse(_endDateController.text),
          description: _descriptionController.text,
          status: "progress",
          totalAmount: 0.0, // Will be calculated from items
          currency: _selectedCurrency!,
        );

        await ApiService().postWipData(newWip);

        // Clear any existing snackbars
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WIP Form Saved Successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Clear the form after successful save
        _clearForm();
        _fetchData(); // Refresh the list
      } catch (e) {
        // Clear any existing snackbars
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        print('Failed to post WIP data: $e');

        String errorMessage = 'Failed to save WIP data';
        if (e.toString().contains('No Internet')) {
          errorMessage = 'No internet connection. Please check your network.';
        } else if (e.toString().contains('Failed to connect')) {
          errorMessage = 'Cannot connect to server. Please try again later.';
        } else if (e.toString().contains('timed out')) {
          errorMessage = 'Request timed out. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                _saveForm();
              },
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _wipCodeController.dispose();
    _projectNameController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WIP Form"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 700, minWidth: 600),
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
                      "WIP Form",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Row 1: WIP Code and Project Name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'WIP Code *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _wipCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter WIP Code',
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
                                  return 'Please enter WIP Code';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  // Calculate total when WIP code changes
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _calculateAndDisplayTotal();
                                  });
                                }
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
                              "Project Name *",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _projectNameController,
                              decoration: InputDecoration(
                                hintText: 'Enter Project Name',
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
                                  return 'Please enter Project Name';
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
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Start Date and End Date
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start Date *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _startDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select Start Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _selectStartDate,
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Start date is required';
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
                              'End Date *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _endDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select End Date',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _selectEndDate,
                                  icon: const Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'End date is required';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Currency
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Currency *",
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
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              items: _currencyOptions.map((currency) {
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
                      const SizedBox(width: 20),

                      // From GL Checkbox
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              ' ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isFromGL,
                                    onChanged: (value) {
                                      setState(() {
                                        _isFromGL = value!;
                                        if (!_isFromGL) {
                                          _selectedGLCode =
                                              _GLCodeOptions.first;
                                        }
                                      });
                                    },
                                  ),
                                  const Text(
                                    'From GL',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // GL Code Dropdown (Conditional)
                  if (_isFromGL)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'GL Code *',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: _selectedGLCode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: _GLCodeOptions.map((code) {
                            return DropdownMenuItem(
                              value: code,
                              child: Text(code),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGLCode = value;
                            });
                          },
                          validator: _isFromGL
                              ? (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Select GL Code';
                                  }
                                  return null;
                                }
                              : null,
                        ),
                      ],
                    ),

                  // Auto-calculated Total Amount Display
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calculate,
                              color: Colors.green[800],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Total Amount (Auto-calculated from WIP Items)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.green[900],
                              ),
                            ),
                            if (_isCalculatingTotal)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Total:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  '${_selectedCurrency} ${_calculatedTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            if (_wipCodeController.text.isNotEmpty)
                              ElevatedButton.icon(
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Recalculate'),
                                onPressed: _calculateAndDisplayTotal,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _wipCodeController.text.isEmpty
                              ? 'Enter a WIP Code to see the calculated total'
                              : 'This amount is calculated from all WIP items linked to this project',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Hidden total amount field for form validation
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      controller: _totalAmountController,
                      validator: (value) {
                        if (_calculatedTotal < 0) {
                          return 'Total amount cannot be negative';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Buttons
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
