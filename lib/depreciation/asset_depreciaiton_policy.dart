import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:flutter/material.dart';

class AssetCategoryPolicyForm extends StatefulWidget {
  final String? categoryName;
  final String? bookName;
  final AssetCategoryPolicy? policy;
  final bool viewMode;
  final VoidCallback? onSave;
  final VoidCallback? onCancel;

  const AssetCategoryPolicyForm({
    super.key,
    this.categoryName,
    this.bookName,
    this.policy,
    this.viewMode = false,
    this.onSave,
    this.onCancel,
  });

  @override
  State<AssetCategoryPolicyForm> createState() =>
      _AssetCategoryPolicyFormState();
}

class _AssetCategoryPolicyFormState extends State<AssetCategoryPolicyForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  late Future<List<Category>> futureCategories;

  // Controllers
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

  List<String> _categoryOptions = [];

  String? _selectedBook;
  String? _selectedCategory;

  // Depreciation Method
  String _depreciationMethod = 'Straight Line';

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
  String _usefulLifeOverride = 'Yes – With Approval';
  String _residualOverride = 'Yes – With Approval';
  String _methodOverride = 'Yes – With Approval';
  String _conventionOverride = 'Yes – With Approval';

  // Flag values for API
  bool _exactDateIFRS = false;
  bool _monthlyProrata = false;
  bool _fullYearNoAcquisition = false;
  bool _halfYear = false;

  @override
  void initState() {
    super.initState();
    futureCategories = apiService.fetchAssetCategory();

    // Set values from parameters
    _selectedBook = widget.bookName ?? _bookOptions.first;
    _selectedCategory = widget.categoryName;

    // If editing/viewing existing policy, populate form
    if (widget.policy != null) {
      _populateFormWithPolicy();
    }

    _updateProRataBasedOnBook();
  }

  void _populateFormWithPolicy() {
    final policy = widget.policy!;

    _depreciationMethod = policy.depreciationMethod;
    _usefulLifeController.text = policy.usefulLife.toString();
    _residualValueController.text = policy.residualValue.toString();
    _useBookDefault = policy.useBookDefault;
    _overrideConvention = policy.overrideConvetion;

    // Set convention flags
    _exactDateIFRS = policy.exactDateIFRS;
    _monthlyProrata = policy.monthlyProrata;
    _fullYearNoAcquisition = policy.fullYearNoAcquisition;
    _halfYear = policy.halfYear;

    // Set selected convention based on flags
    if (_exactDateIFRS)
      _selectedConvention = 'Exact Date (IFRS – Daily Pro-rata)';
    else if (_monthlyProrata)
      _selectedConvention = 'Monthly Pro-rata';
    else if (_fullYearNoAcquisition)
      _selectedConvention = 'Full-Year – No Acquisition Year';
    else if (_halfYear)
      _selectedConvention = 'Half-Year';

    // Set override permissions
    _usefulLifeOverride = policy.allowUsefulLifeOverride
        ? 'Yes – With Approval'
        : 'No';
    _residualOverride = policy.allowResidualOverride
        ? 'Yes – With Approval'
        : 'No';
    _methodOverride = policy.allowMehtodOverride ? 'Yes – With Approval' : 'No';
    _conventionOverride = policy.allowConventionOverride
        ? 'Yes – With Approval'
        : 'No';
  }

  void _updateProRataBasedOnBook() {
    if (widget.viewMode) return; // Don't update in view mode

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
          _exactDateIFRS = true;
          _monthlyProrata = false;
          _fullYearNoAcquisition = false;
          _halfYear = false;
          break;
        case 'Tax Book':
          _useBookDefault = false;
          _overrideConvention = true;
          _selectedConvention = 'Full-Year – No Disposal Year';
          _exactDateIFRS = false;
          _monthlyProrata = false;
          _fullYearNoAcquisition = true;
          _halfYear = false;
          break;
        case 'Management Book':
          // User can choose
          break;
      }
    });
  }

  void _updateConventionFlags(String convention) {
    setState(() {
      _exactDateIFRS = convention == 'Exact Date (IFRS – Daily Pro-rata)';
      _monthlyProrata = convention == 'Monthly Pro-rata';
      _fullYearNoAcquisition = convention == 'Full-Year – No Acquisition Year';
      _halfYear = convention == 'Half-Year';
    });
  }

  @override
  void dispose() {
    _usefulLifeController.dispose();
    _residualValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.viewMode
              ? 'View Policy'
              : 'Asset Category Depreciation Policy',
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: widget.viewMode
            ? [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssetCategoryPolicyForm(
                          categoryName: widget.categoryName,
                          bookName: widget.bookName,
                          policy: widget.policy,
                          viewMode: false,
                        ),
                      ),
                    );
                  },
                ),
              ]
            : [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
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
                      widget.viewMode
                          ? 'View Policy'
                          : 'Asset Category Depreciation Policy',
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
                                onChanged: widget.viewMode
                                    ? null
                                    : (value) {
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
                            FutureBuilder<List<Category>>(
                              future: futureCategories,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  _categoryOptions = snapshot.data!
                                      .map((c) => c.name)
                                      .toList();
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
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
                                    onChanged: widget.viewMode
                                        ? null
                                        : (value) {
                                            setState(() {
                                              _selectedCategory = value;
                                            });
                                          },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Default Depreciation Method
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
                              readOnly: widget.viewMode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                filled: widget.viewMode,
                                fillColor: Colors.grey[100],
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
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              readOnly: widget.viewMode,
                              decoration: InputDecoration(
                                hintText: '0.00',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                filled: widget.viewMode,
                                fillColor: Colors.grey[100],
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
                                    onChanged: widget.viewMode
                                        ? null
                                        : _selectedBook == 'Management Book'
                                        ? (value) {
                                            setState(() {
                                              _useBookDefault = value ?? false;
                                              _overrideConvention =
                                                  !_useBookDefault;
                                            });
                                          }
                                        : null,
                                    activeColor: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Use Book Default',
                                  style: TextStyle(
                                    color:
                                        _selectedBook == 'Management Book' &&
                                            !widget.viewMode
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
                                    onChanged: widget.viewMode
                                        ? null
                                        : _selectedBook == 'Management Book'
                                        ? (value) {
                                            setState(() {
                                              _overrideConvention =
                                                  value ?? false;
                                              _useBookDefault =
                                                  !_overrideConvention;
                                            });
                                          }
                                        : null,
                                    activeColor: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Override Convention for this Category',
                                  style: TextStyle(
                                    color:
                                        _selectedBook == 'Management Book' &&
                                            !widget.viewMode
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
                                          !widget.viewMode &&
                                          (_selectedBook == 'Management Book' ||
                                              (_selectedBook == 'IFRS Book' &&
                                                  option ==
                                                      'Exact Date (IFRS – Daily Pro-rata)') ||
                                              (_selectedBook == 'Tax Book' &&
                                                  option ==
                                                      'Full-Year – No Disposal Year'));

                                      return RadioListTile<String>(
                                        title: Text(
                                          option,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isEnabled || widget.viewMode
                                                ? Colors.black
                                                : Colors.grey,
                                          ),
                                        ),
                                        value: option,
                                        groupValue: _selectedConvention,
                                        onChanged: isEnabled
                                            ? (value) {
                                                setState(() {
                                                  _selectedConvention = value!;
                                                  _updateConventionFlags(value);
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

                  // Save and Clear Buttons (only show in edit mode)
                  if (!widget.viewMode) ...[
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
                  ],

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
          onChanged: widget.viewMode
              ? null
              : (value) {
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
                      onChanged: widget.viewMode
                          ? null
                          : (value) => onChanged(value!),
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
                      onChanged: widget.viewMode
                          ? null
                          : (value) => onChanged(value!),
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
    if (widget.viewMode) return;

    _formKey.currentState?.reset();
    setState(() {
      _selectedBook = widget.bookName ?? _bookOptions.first;
      _selectedCategory = widget.categoryName;
      _depreciationMethod = 'Straight Line';
      _usefulLifeController.clear();
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

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Find category ID from name
        final categories = await apiService.fetchAssetCategory();
        final selectedCategoryObj = categories.firstWhere(
          (c) => c.name == _selectedCategory,
        );

        // Create policy object
        final policy = AssetCategoryPolicy(
          id: widget.policy?.id ?? 0,
          bookLevelPolicyId:
              0, // You'll need to get this from your book selection
          bookLevelPolicyName: _selectedBook!,
          categoryId: selectedCategoryObj.id,
          categoryName: _selectedCategory!,
          depreciationFrequency:
              'Monthly', // You might want to add this to the form
          depreciationMethod: _depreciationMethod,
          usefulLife: int.parse(_usefulLifeController.text),
          period: 'Months', // You might want to add this to the form
          residualValue: double.parse(_residualValueController.text),
          useBookDefault: _useBookDefault,
          overrideConvetion: _overrideConvention,
          exactDateIFRS: _exactDateIFRS,
          monthlyProrata: _monthlyProrata,
          fullYearNoAcquisition: _fullYearNoAcquisition,
          halfYear: _halfYear,
          allowUsefulLifeOverride: _usefulLifeOverride == 'Yes – With Approval',
          allowResidualOverride: _residualOverride == 'Yes – With Approval',
          allowMehtodOverride: _methodOverride == 'Yes – With Approval',
          allowConventionOverride: _conventionOverride == 'Yes – With Approval',
        );

        if (widget.policy == null) {
          // Create new policy
          await apiService.postAssetCategoryPolicy(policy);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Policy created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Update existing policy
          await apiService.updateAssetCategoryPolicy(policy.id, policy);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Policy updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

// Main Navigation for Depreciation Policy Pages
// depreciation_navigation.dart
enum DepreciationPage { category, book, policy, policyForm }

class DepreciationNavigation extends ChangeNotifier {
  DepreciationPage currentPage = DepreciationPage.category;

  int? categoryId;
  String? categoryName;
  String? bookName;

  // Form specific data
  AssetCategoryPolicy? policy;
  bool isViewMode = false;

  void openBooks(int id, String name) {
    _resetFormData();
    categoryId = id;
    categoryName = name;
    currentPage = DepreciationPage.book;
    notifyListeners();
  }

  void openPolicy(String book) {
    _resetFormData();
    bookName = book;
    currentPage = DepreciationPage.policy;
    notifyListeners();
  }

  void openPolicyForm({
    required int categoryId,
    required String categoryName,
    required String bookName,
    AssetCategoryPolicy? policy,
    required bool isViewMode,
  }) {
    this.categoryId = categoryId;
    this.categoryName = categoryName;
    this.bookName = bookName;
    this.policy = policy;
    this.isViewMode = isViewMode;
    currentPage = DepreciationPage.policyForm;
    notifyListeners();
  }

  void backToCategory() {
    _resetFormData();
    currentPage = DepreciationPage.category;
    notifyListeners();
  }

  void backToBook() {
    _resetFormData();
    currentPage = DepreciationPage.book;
    notifyListeners();
  }

  void backToPolicy() {
    _resetFormData();
    currentPage = DepreciationPage.policy;
    notifyListeners();
  }

  void _resetFormData() {
    policy = null;
    isViewMode = false;
  }
}

// Depreciation Setting Page
class DepreciationSettingPage extends StatelessWidget {
  final DepreciationNavigation nav;

  const DepreciationSettingPage({super.key, required this.nav});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: nav,
      builder: (context, _) {
        switch (nav.currentPage) {
          case DepreciationPage.category:
            return AssetCategoryListPage(nav: nav);

          case DepreciationPage.book:
            return BookSelectionPage(
              nav: nav,
              categoryId: nav.categoryId!,
              categoryName: nav.categoryName!,
            );

          case DepreciationPage.policy:
            return AssetCategoryPolicyPage(
              nav: nav,
              categoryId: nav.categoryId!,
              categoryName: nav.categoryName!,
              bookName: nav.bookName!,
            );

          case DepreciationPage.policyForm:
            return _buildPolicyFormPage();
        }
      },
    );
  }

  Widget _buildPolicyFormPage() {
    return Column(
      children: [
        // Custom header with back button
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: nav.backToPolicy,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nav.categoryName ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      nav.bookName ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Form
        Expanded(
          child: AssetCategoryPolicyForm(
            key: ValueKey(
              '${nav.categoryId}_${nav.bookName}_${nav.isViewMode}',
            ),
            categoryName: nav.categoryName,
            bookName: nav.bookName,
            policy: nav.policy,
            viewMode: nav.isViewMode,
            onSave: () {
              nav.backToPolicy();
            },
            onCancel: () {
              nav.backToPolicy();
            },
          ),
        ),
      ],
    );
  }
}

//asset category list page

class AssetCategoryListPage extends StatefulWidget {
  final DepreciationNavigation nav;

  const AssetCategoryListPage({super.key, required this.nav});

  @override
  State<AssetCategoryListPage> createState() => _AssetCategoryListPageState();
}

class _AssetCategoryListPageState extends State<AssetCategoryListPage> {
  final ApiService apiService = ApiService();

  late Future<List<Category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = apiService.fetchAssetCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final categories = snapshot.data ?? [];

              if (categories.isEmpty) {
                return const Center(child: Text("No Categories Found"));
              }

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return ListTile(
                    leading: const Icon(Icons.category),
                    title: Text(category.name),
                    subtitle: Text(category.categoryCode),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      widget.nav.openBooks(category.id, category.name);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Asset Categories Derepciation Policy",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Book Selection Page

class BookSelectionPage extends StatelessWidget {
  final DepreciationNavigation nav;
  final int categoryId;
  final String categoryName;

  BookSelectionPage({
    super.key,
    required this.nav,
    required this.categoryId,
    required this.categoryName,
  });

  final List<String> books = ["Tax Book", "IFRS Book", "Management Book"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.book),
                title: Text(books[index]),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  nav.openPolicy(books[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: nav.backToCategory,
        ),
        Text(
          categoryName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

//asset category policy page
class AssetCategoryPolicyPage extends StatefulWidget {
  final DepreciationNavigation nav;
  final int categoryId;
  final String categoryName;
  final String bookName;

  const AssetCategoryPolicyPage({
    super.key,
    required this.nav,
    required this.categoryId,
    required this.categoryName,
    required this.bookName,
  });

  @override
  State<AssetCategoryPolicyPage> createState() =>
      _AssetCategoryPolicyPageState();
}

class _AssetCategoryPolicyPageState extends State<AssetCategoryPolicyPage> {
  final ApiService apiService = ApiService();
  late Future<List<AssetCategoryPolicy>> futurePolicies;

  @override
  void initState() {
    super.initState();
    _refreshPolicies();
  }

  void _refreshPolicies() {
    setState(() {
      futurePolicies = apiService.fetchAssetCategoryPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: FutureBuilder<List<AssetCategoryPolicy>>(
            future: futurePolicies,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text("Error: ${snapshot.error}"),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshPolicies,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final policies = snapshot.data ?? [];

              final filteredPolicies = policies
                  .where(
                    (p) =>
                        p.categoryId == widget.categoryId &&
                        p.bookLevelPolicyName == widget.bookName,
                  )
                  .toList();

              if (filteredPolicies.isEmpty) {
                return _buildEmptyState();
              }

              return _buildPolicyView(filteredPolicies.first);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.nav.backToBook,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoryName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.bookName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              "No Depreciation Policy Found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "This asset category doesn't have a depreciation policy for ${widget.bookName}.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text(
                'Add Depreciation Policy',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AssetCategoryPolicyForm(
                      categoryName: widget.categoryName,
                      bookName: widget.bookName,
                    ),
                  ),
                );

                if (result == true) {
                  _refreshPolicies();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Policy added successfully for ${widget.bookName}',
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyView(AssetCategoryPolicy policy) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: Colors.blue[800],
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              policy.categoryName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              policy.bookLevelPolicyName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30),

                  // Policy Details Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildInfoTile(
                        'Depreciation Method',
                        policy.depreciationMethod,
                        Icons.calculate,
                      ),
                      _buildInfoTile(
                        'Useful Life',
                        '${policy.usefulLife} months',
                        Icons.timer,
                      ),
                      _buildInfoTile(
                        'Residual Value',
                        '${policy.residualValue}%',
                        Icons.percent,
                      ),
                      _buildInfoTile(
                        'Frequency',
                        policy.depreciationFrequency,
                        Icons.repeat,
                      ),
                    ],
                  ),

                  const Divider(height: 20),

                  // Convention Details
                  const Text(
                    'Convention Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (policy.exactDateIFRS)
                        _buildChip('Exact Date IFRS', Colors.blue),
                      if (policy.monthlyProrata)
                        _buildChip('Monthly Pro-rata', Colors.green),
                      if (policy.fullYearNoAcquisition)
                        _buildChip('Full Year - No Acquisition', Colors.orange),
                      if (policy.halfYear)
                        _buildChip('Half Year', Colors.purple),
                      if (policy.useBookDefault)
                        _buildChip('Use Book Default', Colors.grey),
                    ],
                  ),

                  const Divider(height: 20),

                  // Override Permissions
                  const Text(
                    'Override Permissions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      _buildPermissionRow(
                        'Useful Life Override',
                        policy.allowUsefulLifeOverride,
                      ),
                      _buildPermissionRow(
                        'Residual Override',
                        policy.allowResidualOverride,
                      ),
                      _buildPermissionRow(
                        'Method Override',
                        policy.allowMehtodOverride,
                      ),
                      _buildPermissionRow(
                        'Convention Override',
                        policy.allowConventionOverride,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Policy'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.blue[800]!),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssetCategoryPolicyForm(
                          categoryName: widget.categoryName,
                          bookName: widget.bookName,
                          policy: policy,
                          viewMode: false,
                        ),
                      ),
                    );

                    if (result == true) {
                      _refreshPolicies();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Policy updated successfully'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssetCategoryPolicyForm(
                          categoryName: widget.categoryName,
                          bookName: widget.bookName,
                          policy: policy,
                          viewMode: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blue[800]),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: color)),
    );
  }

  TableRow _buildPermissionRow(String label, bool value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                value ? Icons.check_circle : Icons.cancel,
                color: value ? Colors.green : Colors.red[300],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(value ? 'Allowed' : 'Not Allowed'),
            ],
          ),
        ),
      ],
    );
  }
}
