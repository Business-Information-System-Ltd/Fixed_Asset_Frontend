import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WipItemForm extends StatefulWidget {
  final Wip? selectedWipProject;

  const WipItemForm({super.key, this.selectedWipProject});

  @override
  State<WipItemForm> createState() => _WipItemFormState();
}

class _WipItemFormState extends State<WipItemForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _unitCostController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _transactionDateController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _wipProjectController = TextEditingController();

  // Dropdown
  String? _selectedCurrency;
  String? _selectedCostType;
  Wip? _selectedWipProject;

  // Lists
  final List<String> _currencyOptions = ['MMK', 'USD'];
  final List<String> _costTypeOptions = ['cash', 'bank'];
  final Map<String, String> _costTypeDisplay = {'cash': 'Cash', 'bank': 'Bank'};

  List<Wip> _wipProjects = [];
  List<Wip> _filteredWipProjects = [];

  bool _isLoading = false;
  bool _isFetchingProjects = false;
  bool _isPreselectedProject = false;

  @override
  void initState() {
    super.initState();

    // Check if a project was preselected
    if (widget.selectedWipProject != null) {
      _selectedWipProject = widget.selectedWipProject;
      _isPreselectedProject = true;
      _wipProjectController.text =
          '${_selectedWipProject!.wipCode} - ${_selectedWipProject!.projectName}';
    }

    // Set default values
    _selectedCurrency = _currencyOptions.first;
    _selectedCostType = _costTypeOptions.first;
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _transactionDateController.text = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());

    // Initialize lists
    _wipProjects = [];
    _filteredWipProjects = [];

    // Fetch WIP projects (only if no preselected project)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isPreselectedProject) {
        _fetchWipProjects();
      }
    });
  }

  Future<void> _fetchWipProjects() async {
    if (_isFetchingProjects) return;

    setState(() {
      _isFetchingProjects = true;
    });

    try {
      List<Wip> data = await ApiService().fetchWipData();

      // Filter projects with "Progress" status
      List<Wip> progressProjects = data
          .where((project) => project.status.toLowerCase() == 'progress')
          .toList();

      print("✅ Fetched ${data.length} WIP projects");
      print(
        "✅ Found ${progressProjects.length} projects with 'Progress' status",
      );

      setState(() {
        _wipProjects = data;
        _filteredWipProjects = progressProjects;

        if (progressProjects.isNotEmpty && _selectedWipProject == null) {
          _selectedWipProject = progressProjects.first;
          _wipProjectController.text =
              '${_selectedWipProject!.wipCode} - ${_selectedWipProject!.projectName}';
        }
      });
    } catch (e) {
      print('❌ Error fetching WIP projects: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load WIP projects: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        _wipProjects = [];
        _filteredWipProjects = [];
        if (!_isPreselectedProject) {
          _selectedWipProject = null;
        }
      });
    } finally {
      setState(() {
        _isFetchingProjects = false;
      });
    }
  }

  void _calculateTotal() {
    if (_unitCostController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      try {
        final unitCost = double.parse(_unitCostController.text);
        final quantity = double.parse(_quantityController.text);
        final total = unitCost * quantity;
        _totalCostController.text = total.toStringAsFixed(2);
      } catch (e) {
        _totalCostController.text = '';
      }
    } else {
      _totalCostController.text = '';
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTransactionDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _transactionDateController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _itemCodeController.clear();
    _itemNameController.clear();
    _unitCostController.clear();
    _quantityController.clear();
    _totalCostController.clear();
    _transactionDateController.clear();
    _descriptionController.clear();

    setState(() {
      _selectedCurrency = _currencyOptions.first;
      _selectedCostType = _costTypeOptions.first;

      if (_isPreselectedProject && widget.selectedWipProject != null) {
        _selectedWipProject = widget.selectedWipProject;
        _wipProjectController.text =
            '${_selectedWipProject!.wipCode} - ${_selectedWipProject!.projectName}';
      } else if (_filteredWipProjects.isNotEmpty) {
        _selectedWipProject = _filteredWipProjects.first;
        _wipProjectController.text =
            '${_selectedWipProject!.wipCode} - ${_selectedWipProject!.projectName}';
      } else {
        _selectedWipProject = null;
        _wipProjectController.clear();
      }

      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _transactionDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now());
    });
  }

  // NEW: Update WIP project total after saving item
  Future<void> _updateWipProjectTotal() async {
    if (_selectedWipProject == null) return;

    try {
      print(
        '🔄 Updating WIP project total for ${_selectedWipProject!.wipCode}',
      );
      await ApiService().calculateAndUpdateWipTotal(_selectedWipProject!.id);
      print('✅ WIP project total updated successfully');
    } catch (e) {
      print('❌ Error updating WIP project total: $e');
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedWipProject == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a WIP project'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Create WipItem object
        final wipItem = WipItem(
          id: 0,
          itemCode: _itemCodeController.text.trim(),
          itemName: _itemNameController.text.trim(),
          costType: _selectedCostType!,
          description: _descriptionController.text.trim(),
          quantity: double.parse(_quantityController.text),
          unitCost: double.parse(_unitCostController.text),
          totalCost: double.parse(_totalCostController.text),
          currency: _selectedCurrency!,
          transactionDate: DateTime.parse(_transactionDateController.text),
          wipId: _selectedWipProject!.id,
          wipCode: _selectedWipProject!.wipCode,
        );

        print('📤 Submitting WIP Item:');
        print('   Item Code: ${wipItem.itemCode}');
        print('   Total Cost: ${wipItem.totalCost} ${wipItem.currency}');
        print('   WIP Project: ${wipItem.wipCode} (ID: ${wipItem.wipId})');

        // Save WIP item
        await ApiService().postWipItemData(wipItem);

        // ✅ CRITICAL: Update the WIP project total amount
        await _updateWipProjectTotal();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('WIP Item saved successfully! WIP total updated.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Clear form after successful save
        Future.delayed(const Duration(milliseconds: 500), () {
          _clearForm();
        });
      } catch (e) {
        print('❌ Error saving WIP item: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save WIP item: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _itemCodeController.dispose();
    _dateController.dispose();
    _itemNameController.dispose();
    _unitCostController.dispose();
    _quantityController.dispose();
    _totalCostController.dispose();
    _transactionDateController.dispose();
    _descriptionController.dispose();
    _wipProjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isPreselectedProject
              ? 'Add Item to ${_selectedWipProject?.wipCode}'
              : 'WIP Item Form',
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, minWidth: 500),
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
                  // Title
                  Center(
                    child: Text(
                      _isPreselectedProject ? 'Add WIP Item' : 'WIP Item Form',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Row 1: Item Code and Date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Item Code *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _itemCodeController,
                              decoration: InputDecoration(
                                hintText: 'Enter item code',
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
                                  return 'Item code is required';
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
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select date',
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
                                  onPressed: _selectDate,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Item Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Item Name *',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _itemNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter item name',
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
                            return 'Item name is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Description
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
                          hintText: 'Enter description (optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Unit Cost, Currency, Quantity, Total Cost
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unit Cost *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _unitCostController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
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
                              onChanged: (_) => _calculateTotal(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Unit cost is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid number';
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
                              'Currency *',
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
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _quantityController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
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
                              onChanged: (_) => _calculateTotal(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Quantity is required';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Enter a valid number';
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
                              'Total Cost',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _totalCostController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Cost Type Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cost Type *',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: _selectedCostType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: _costTypeOptions.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(_costTypeDisplay[type] ?? type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCostType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Select cost type';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Transaction Date and WIP Project
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Transaction Date *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _transactionDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Select date',
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
                                  onPressed: _selectTransactionDate,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Transaction date is required';
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
                              'WIP Project *',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_isPreselectedProject)
                              TextFormField(
                                controller: _wipProjectController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Select WIP project',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                validator: (value) {
                                  if (_selectedWipProject == null) {
                                    return 'WIP project is required';
                                  }
                                  return null;
                                },
                              )
                            else if (_filteredWipProjects.isEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.grey.shade100,
                                ),
                                child: const Text(
                                  'No Progress projects available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            else
                              DropdownButtonFormField<Wip>(
                                value: _selectedWipProject,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                                items: _filteredWipProjects.map((project) {
                                  return DropdownMenuItem<Wip>(
                                    value: project,
                                    child: Text(
                                      '${project.wipCode} - ${project.projectName}',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedWipProject = value;
                                    _wipProjectController.text =
                                        '${value!.wipCode} - ${value.projectName}';
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Select a WIP project';
                                  }
                                  return null;
                                },
                                isExpanded: true,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Info message
                  if (!_isPreselectedProject && _filteredWipProjects.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: Colors.orange[800], size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No WIP projects with "Progress" status found. Please create a Progress project first.',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _fetchWipProjects,
                            child: const Text(
                              'Refresh',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Note about auto-calculation
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[800],
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Note: The total amount of the WIP project will be automatically updated with this item\'s cost.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed:
                            (_isLoading ||
                                (!_isPreselectedProject &&
                                    _filteredWipProjects.isEmpty))
                            ? null
                            : _saveForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              (!_isPreselectedProject &&
                                  _filteredWipProjects.isEmpty)
                              ? Colors.grey
                              : Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
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
                        onPressed: _isLoading ? null : _clearForm,
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
