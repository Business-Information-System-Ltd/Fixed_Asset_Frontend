import 'package:fixed_asset_frontend/depreciation/depreciation_convention.dart';
import 'package:flutter/material.dart';

class AssetCategoryPolicyForm extends StatefulWidget {
  const AssetCategoryPolicyForm({super.key});

  @override
  State<AssetCategoryPolicyForm> createState() =>
      _AssetCategoryPolicyFormState();
}

class _AssetCategoryPolicyFormState extends State<AssetCategoryPolicyForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _usefulLifeController = TextEditingController();
  final TextEditingController _residualValueController =
      TextEditingController();

  // Dropdown values
  final List<String> _bookOptions = [
    'Default',
    'IFRS Book',
    'Tax Book',
    'Management Book',
  ];
  final List<String> _categoryOptions = [
    'Laptop',
    'Desktop',
    'Server',
    'Furniture',
    'Vehicle',
    'Building',
  ];

  String? _selectedBook;
  String? _selectedCategory;

  // Depreciation Method
  String _depreciationMethod =
      'Straight Line'; // 'Straight Line', 'Reducing Balance', 'Units of Prod'

  // Pro-rata Override
  bool _useBookDefault = true;
  bool _overrideConvention = false;

  // Convention options
  String _selectedConvention = 'Exact Date (IFRS – Daily Pro-rata)';
  final List<String> _conventionOptions = [
    'Exact Date (IFRS – Daily Pro-rata)',
    'Monthly Pro-rata',
    'Full-Year – No Acquisition Year',
    'Full-Year – No Disposal Year',
    'Half-Year',
  ];

  // Override Permissions
  String _usefulLifeOverride =
      'Yes – With Approval'; // 'Yes – With Approval', 'No'
  String _residualOverride = 'Yes – With Approval';
  String _methodOverride = 'Yes – With Approval';
  String _conventionOverride = 'Yes – With Approval';

  @override
  void initState() {
    super.initState();
    // Set default values
    _selectedBook = _bookOptions.first;
    _selectedCategory = _categoryOptions.first;
    _updateProRataBasedOnBook();
  }

  void _updateProRataBasedOnBook() {
    setState(() {
      switch (_selectedBook) {
        case 'Default':
          _useBookDefault = true;
          _overrideConvention = false;
          break;
        case 'IFRS Book':
          _useBookDefault = false;
          _overrideConvention = true;
          _selectedConvention = 'Exact Date (IFRS – Daily Pro-rata)';
          break;
        case 'Tax Book':
          _useBookDefault = false;
          _overrideConvention = true;
          _selectedConvention = 'Full-Year – No Disposal Year';
          break;
        case 'Management Book':
          // User can choose, so we don't force any selection
          // Keep current selection or default to book default
          break;
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _usefulLifeController.dispose();
    _residualValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Category Depreciation Policy'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800, minWidth: 600),
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
                      'Asset Category Depreciation Policy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Asset Category Policy Section
                  const Text(
                    'Asset Category Policy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  // Select Book Dropdown
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Book:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedBook,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: _bookOptions.map((book) {
                                  return DropdownMenuItem(
                                    value: book,
                                    child: Text(book),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedBook = value;
                                    _updateProRataBasedOnBook();
                                  });
                                },
                              ),
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
                              'Select Category:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: _categoryOptions.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Default Depreciation Method (Column layout)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Default Depreciation Method:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            _buildMethodRadio('Straight Line'),
                            const Divider(),
                            _buildMethodRadio('Reducing Balance'),
                            const Divider(),
                            _buildMethodRadio('Units of Prod'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Default Useful Life and Residual Value
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Default Useful Life (Months):',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _usefulLifeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                // hintText: '36',
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
                                  return 'Required';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Enter a valid number';
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
                              'Default Residual Value (%):',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _residualValueController,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
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
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Pro-rata Override Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pro-rata Override (Category):',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            // Use Book Default option
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _useBookDefault,
                                    onChanged:
                                        _selectedBook == 'Management Book'
                                        ? (value) {
                                            setState(() {
                                              _useBookDefault = value ?? false;
                                              _overrideConvention =
                                                  !_useBookDefault;
                                            });
                                          }
                                        : null, // Disabled for other books
                                    activeColor: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Use Book Default',
                                  style: TextStyle(
                                    color: _selectedBook == 'Management Book'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),

                            // Override Convention option
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _overrideConvention,
                                    onChanged:
                                        _selectedBook == 'Management Book'
                                        ? (value) {
                                            setState(() {
                                              _overrideConvention =
                                                  value ?? false;
                                              _useBookDefault =
                                                  !_overrideConvention;
                                            });
                                          }
                                        : null, // Disabled for other books
                                    activeColor: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Override Convention for this Category',
                                  style: TextStyle(
                                    color: _selectedBook == 'Management Book'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            if (_overrideConvention ||
                                _selectedBook == 'IFRS Book' ||
                                _selectedBook == 'Tax Book')
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 32,
                                  top: 12,
                                ),
                                child: Column(
                                  children: [
                                    const Text('Convention:'),
                                    const SizedBox(height: 8),
                                    ..._conventionOptions.map((option) {
                                      bool isEnabled =
                                          _selectedBook == 'Management Book' ||
                                          (_selectedBook == 'IFRS Book' &&
                                              option ==
                                                  'Exact Date (IFRS – Daily Pro-rata)') ||
                                          (_selectedBook == 'Tax Book' &&
                                              option ==
                                                  'Full-Year – No Disposal Year');

                                      return RadioListTile<String>(
                                        title: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isEnabled
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        value: option,
                                        groupValue: isEnabled
                                            ? _selectedConvention
                                            : null,
                                        onChanged: isEnabled
                                            ? (value) {
                                                setState(() {
                                                  _selectedConvention = value!;
                                                });
                                              }
                                            : null,
                                        activeColor: Colors.blue[800],
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Override Permission Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Override Permission:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            _buildPermissionRow(
                              'Allow Useful Life Override:',
                              _usefulLifeOverride,
                              (value) {
                                setState(() {
                                  _usefulLifeOverride = value;
                                });
                              },
                            ),
                            const Divider(),
                            _buildPermissionRow(
                              'Allow Residual Override:',
                              _residualOverride,
                              (value) {
                                setState(() {
                                  _residualOverride = value;
                                });
                              },
                            ),
                            const Divider(),
                            _buildPermissionRow(
                              'Allow Method Override:',
                              _methodOverride,
                              (value) {
                                setState(() {
                                  _methodOverride = value;
                                });
                              },
                            ),
                            const Divider(),
                            _buildPermissionRow(
                              'Allow Convention Override:',
                              _conventionOverride,
                              (value) {
                                setState(() {
                                  _conventionOverride = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Save and Clear Buttons
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
                          side: BorderSide(color: Colors.blue[800]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodRadio(String method) {
    return Row(
      children: [
        Radio<String>(
          value: method,
          groupValue: _depreciationMethod,
          onChanged: (value) {
            setState(() {
              _depreciationMethod = value!;
            });
          },
          activeColor: Colors.blue[800],
        ),
        const SizedBox(width: 8),
        Text(method),
      ],
    );
  }

  Widget _buildPermissionRow(
    String label,
    String groupValue,
    Function(String) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes – With Approval',
                      groupValue: groupValue,
                      onChanged: (value) => onChanged(value!),
                      activeColor: Colors.blue[800],
                    ),
                    const Text('Yes', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'No',
                      groupValue: groupValue,
                      onChanged: (value) => onChanged(value!),
                      activeColor: Colors.blue[800],
                    ),
                    const Text('No', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _codeController.clear();
      _selectedBook = _bookOptions.first;
      _selectedCategory = _categoryOptions.first;
      _depreciationMethod = 'Straight Line';
      _usefulLifeController.text = '';
      _residualValueController.text = '0.00';
      _usefulLifeOverride = 'Yes – With Approval';
      _residualOverride = 'Yes – With Approval';
      _methodOverride = 'Yes – With Approval';
      _conventionOverride = 'Yes – With Approval';
      _updateProRataBasedOnBook();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Form cleared'),
        backgroundColor: Colors.blue[800],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'code': _codeController.text,
        'book': _selectedBook,
        'category': _selectedCategory,
        'depreciationMethod': _depreciationMethod,
        'usefulLife': int.parse(_usefulLifeController.text),
        'residualValue': double.parse(_residualValueController.text),
        'useBookDefault': _useBookDefault,
        'overrideConvention': _overrideConvention,
        'selectedConvention': _selectedConvention,
        'usefulLifeOverride': _usefulLifeOverride,
        'residualOverride': _residualOverride,
        'methodOverride': _methodOverride,
        'conventionOverride': _conventionOverride,
      };

      print('✅ Saved data: $formData');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Asset Category Policy saved successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
