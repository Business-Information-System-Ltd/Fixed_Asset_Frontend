import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FixAssetForm extends StatefulWidget {
  const FixAssetForm({super.key});

  @override
  State<FixAssetForm> createState() => _FixAssetFormState();
}

class _FixAssetFormState extends State<FixAssetForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Controllers - Tab 1 (Asset Identification)
  final TextEditingController _assetCodeController = TextEditingController();
  final TextEditingController _acquisitionDateController =
      TextEditingController();
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _assetModelController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _wipProjectController = TextEditingController();

  // Controllers - Tab 2 (Cost Details)
  final TextEditingController _acquisitionCostController =
      TextEditingController();
  final TextEditingController _transportationFeeController =
      TextEditingController();
  final TextEditingController _taxFeeController = TextEditingController();
  final TextEditingController _otherFeeController = TextEditingController();
  final TextEditingController _additionalCostController =
      TextEditingController();
  final TextEditingController _residualValueController =
      TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController(
    text: '1.00',
  );
  final TextEditingController _totalAmountController = TextEditingController();

  // Controllers - Tab 3 (Account Details & Depreciation)
  final TextEditingController _capitalizationDateController =
      TextEditingController();
  final TextEditingController _usefulLifeController = TextEditingController();

  // DropDown Values - Tab 1
  String? _selectedAssetGroup;
  String? _selectedSourceType;
  String? _selectedAssetType;
  String? _selectedAssetStatus;
  String? _selectedWIPProject;

  // DropDown Values - Tab 3
  String? _selectedFixedAssetAccount;
  String? _selectedDepreciationAccount;
  String? _selectedExpenseAccount;
  String? _selectedDepreciationMethod;
  String? _selectedUsefulLife;
  String? _selectedComputation;

  // Currency for each cost field - Tab 2
  String _acquisitionCostCurrency = 'MMK';
  String _transportationCurrency = 'MMK';
  String _taxCurrency = 'MMK';
  String _otherCurrency = 'MMK';
  String _additionalCurrency = 'MMK';
  String _residualCurrency = 'MMK';

  // Options Lists
  final List<String> _currencyOptions = ['MMK', 'USD'];
  final List<String> _assetGroupOptions = [
    'Land',
    'Building',
    'Machine',
    'Furniture',
    'Vehicle',
    'Equipment',
  ];
  final List<String> _sourceTypeOptions = ['WIP', 'Direct', 'General Ledger'];
  final List<String> _assetTypeOptions = [
    'Main Asset',
    'Component',
    'Leased Asset',
  ];
  final List<String> _assetStatusOptions = [
    'Finished',
    'Ready to use',
    'No depreciation',
    'Disposed',
  ];
  final List<String> _accountCodeOptions = [
    '1010 - Land',
    '1020 - Building',
    '1030 - Machinery',
    '1040 - Furniture',
    '1050 - Vehicles',
  ];
  final List<String> _depreciationMethodOptions = [
    'Straight Line',
    'Reducing Balance',
    'Sum of Years Digits',
    'Double Declining',
  ];
  final List<String> _usefulLifeOptions = ['Years', 'Months', 'Days'];
  final List<String> _computationOptions = ['Yearly', 'Monthly', 'Daily'];

  // WIP Projects List (Mock data)
  final List<Map<String, String>> _wipProjects = [
    {'code': 'WIP001', 'name': 'Factory Construction', 'status': 'In Progress'},
    {
      'code': 'WIP002',
      'name': 'Equipment Installation',
      'status': '70% Complete',
    },
    {'code': 'WIP003', 'name': 'Office Renovation', 'status': 'In Progress'},
    {'code': 'WIP004', 'name': 'IT Infrastructure', 'status': '90% Complete'},
  ];

  // Depreciation Settings - Tab 3
  String _depreciationFrequency = 'Monthly';
  String _postingDateRule = 'End of Month';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    _initializeDefaultValues();

    // Add listeners for automatic total calculation
    _acquisitionCostController.addListener(_calculateTotal);
    _transportationFeeController.addListener(_calculateTotal);
    _taxFeeController.addListener(_calculateTotal);
    _otherFeeController.addListener(_calculateTotal);
    _additionalCostController.addListener(_calculateTotal);
    _exchangeRateController.addListener(_calculateTotal);
  }

  void _initializeDefaultValues() {
    // Tab 1 defaults
    _selectedAssetGroup = _assetGroupOptions.first;
    _selectedSourceType = _sourceTypeOptions.first;
    _selectedAssetType = _assetTypeOptions.first;
    _selectedAssetStatus = _assetStatusOptions.first;

    // Tab 3 defaults
    _selectedFixedAssetAccount = _accountCodeOptions.first;
    _selectedDepreciationAccount = _accountCodeOptions[1];
    _selectedExpenseAccount = _accountCodeOptions[2];
    _selectedDepreciationMethod = _depreciationMethodOptions.first;
    _selectedUsefulLife = _usefulLifeOptions.first;
    _selectedComputation = _computationOptions.first;
  }

  void _calculateTotal() {
    double acquisition =
        double.tryParse(_acquisitionCostController.text) ?? 0.0;
    double transportation =
        double.tryParse(_transportationFeeController.text) ?? 0.0;
    double tax = double.tryParse(_taxFeeController.text) ?? 0.0;
    double other = double.tryParse(_otherFeeController.text) ?? 0.0;
    double additional = double.tryParse(_additionalCostController.text) ?? 0.0;

    double totalInMMK = 0.0;
    double exchangeRate = double.tryParse(_exchangeRateController.text) ?? 1.0;

    // Convert each cost to MMK based on its currency
    totalInMMK += _acquisitionCostCurrency == 'MMK'
        ? acquisition
        : acquisition * exchangeRate;
    totalInMMK += _transportationCurrency == 'MMK'
        ? transportation
        : transportation * exchangeRate;
    totalInMMK += _taxCurrency == 'MMK' ? tax : tax * exchangeRate;
    totalInMMK += _otherCurrency == 'MMK' ? other : other * exchangeRate;
    totalInMMK += _additionalCurrency == 'MMK'
        ? additional
        : additional * exchangeRate;

    _totalAmountController.text = totalInMMK.toStringAsFixed(2);
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showWIPSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select WIP Project'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _wipProjects.length,
              itemBuilder: (context, index) {
                final project = _wipProjects[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text('${project['code']} - ${project['name']}'),
                    subtitle: Text('Status: ${project['status']}'),
                    onTap: () {
                      setState(() {
                        _selectedWIPProject = project['code'];
                        _wipProjectController.text =
                            '${project['code']} - ${project['name']}';
                      });
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  bool _validateTab1() {
    return _selectedAssetGroup != null &&
        _assetCodeController.text.isNotEmpty &&
        _acquisitionDateController.text.isNotEmpty &&
        _assetNameController.text.isNotEmpty &&
        _selectedSourceType != null &&
        (_selectedSourceType != 'WIP' ||
            (_selectedSourceType == 'WIP' &&
                _wipProjectController.text.isNotEmpty)) &&
        _selectedAssetType != null &&
        _selectedAssetStatus != null;
  }

  bool _validateTab2() {
    return _acquisitionCostController.text.isNotEmpty &&
        _residualValueController.text.isNotEmpty;
  }

  bool _validateTab3() {
    return _selectedFixedAssetAccount != null &&
        _selectedDepreciationAccount != null &&
        _selectedExpenseAccount != null &&
        _selectedDepreciationMethod != null &&
        _capitalizationDateController.text.isNotEmpty &&
        _usefulLifeController.text.isNotEmpty &&
        _selectedUsefulLife != null &&
        _selectedComputation != null;
  }

  void _navigateToTab(int targetIndex) {
    // Validate current tab before navigating
    bool canNavigate = false;

    if (_currentTabIndex == 0) {
      canNavigate = _validateTab1();
      if (!canNavigate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required fields in Asset Info tab'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_currentTabIndex == 1) {
      canNavigate = _validateTab2();
      if (!canNavigate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill all required fields in Cost Details tab',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      canNavigate = true;
    }

    if (canNavigate) {
      _tabController.animateTo(targetIndex);
    }
  }

  void _clearTab1() {
    // Clear Tab 1 controllers
    _assetCodeController.clear();
    _acquisitionDateController.clear();
    _assetNameController.clear();
    _assetModelController.clear();
    _supplierController.clear();
    _descriptionController.clear();
    _wipProjectController.clear();

    // Reset Tab 1 dropdowns
    setState(() {
      _selectedAssetGroup = _assetGroupOptions.first;
      _selectedSourceType = _sourceTypeOptions.first;
      _selectedAssetType = _assetTypeOptions.first;
      _selectedAssetStatus = _assetStatusOptions.first;
      _selectedWIPProject = null;
    });
  }

  void _clearTab2() {
    // Clear Tab 2 controllers
    _acquisitionCostController.clear();
    _transportationFeeController.clear();
    _taxFeeController.clear();
    _otherFeeController.clear();
    _additionalCostController.clear();
    _residualValueController.clear();
    _exchangeRateController.text = '1.00';
    _totalAmountController.clear();

    // Reset Tab 2 currencies
    setState(() {
      _acquisitionCostCurrency = 'MMK';
      _transportationCurrency = 'MMK';
      _taxCurrency = 'MMK';
      _otherCurrency = 'MMK';
      _additionalCurrency = 'MMK';
      _residualCurrency = 'MMK';
    });
  }

  void _clearTab3() {
    // Clear Tab 3 controllers
    _capitalizationDateController.clear();
    _usefulLifeController.clear();

    // Reset Tab 3 dropdowns and settings
    setState(() {
      _selectedFixedAssetAccount = _accountCodeOptions.first;
      _selectedDepreciationAccount = _accountCodeOptions[1];
      _selectedExpenseAccount = _accountCodeOptions[2];
      _selectedDepreciationMethod = _depreciationMethodOptions.first;
      _selectedUsefulLife = _usefulLifeOptions.first;
      _selectedComputation = _computationOptions.first;

      _depreciationFrequency = 'Monthly';
      _postingDateRule = 'End of Month';
    });
  }

  void _saveForm() {
    // Validate all tabs before saving
    if (_validateTab1() && _validateTab2() && _validateTab3()) {
      // Here you would save all data from all tabs to database
      Map<String, dynamic> allFormData = {
        // Tab 1 data
        'assetGroup': _selectedAssetGroup,
        'assetCode': _assetCodeController.text,
        'acquisitionDate': _acquisitionDateController.text,
        'sourceType': _selectedSourceType,
        'assetName': _assetNameController.text,
        'assetModel': _assetModelController.text,
        'wipProject': _selectedWIPProject,
        'assetType': _selectedAssetType,
        'supplier': _supplierController.text,
        'assetStatus': _selectedAssetStatus,
        'description': _descriptionController.text,

        // Tab 2 data
        'acquisitionCost':
            double.tryParse(_acquisitionCostController.text) ?? 0,
        'acquisitionCostCurrency': _acquisitionCostCurrency,
        'transportationCost':
            double.tryParse(_transportationFeeController.text) ?? 0,
        'transportationCurrency': _transportationCurrency,
        'taxFees': double.tryParse(_taxFeeController.text) ?? 0,
        'taxCurrency': _taxCurrency,
        'otherFees': double.tryParse(_otherFeeController.text) ?? 0,
        'otherCurrency': _otherCurrency,
        'additionalCost': double.tryParse(_additionalCostController.text) ?? 0,
        'additionalCurrency': _additionalCurrency,
        'residualValue': double.tryParse(_residualValueController.text) ?? 0,
        'residualCurrency': _residualCurrency,
        'exchangeRate': double.tryParse(_exchangeRateController.text) ?? 1.0,
        'totalAmount': double.tryParse(_totalAmountController.text) ?? 0,

        // Tab 3 data
        'fixedAssetAccount': _selectedFixedAssetAccount,
        'depreciationAccount': _selectedDepreciationAccount,
        'expenseAccount': _selectedExpenseAccount,
        'depreciationMethod': _selectedDepreciationMethod,
        'capitalizationDate': _capitalizationDateController.text,
        'usefulLife': double.tryParse(_usefulLifeController.text) ?? 0,
        'usefulLifeUnit': _selectedUsefulLife,
        'computation': _selectedComputation,
        'depreciationFrequency': _depreciationFrequency,
        'postingDateRule': _postingDateRule,
      };

      // Print for demonstration (replace with actual database save)
      print('Saving to database: $allFormData');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form saved successfully!')));
    } else {
      String errorMessage = 'Please fill all required fields in:\n';
      if (!_validateTab1()) errorMessage += '• Asset Info tab\n';
      if (!_validateTab2()) errorMessage += '• Cost Details tab\n';
      if (!_validateTab3()) errorMessage += '• Account & Depr tab\n';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildCostField({
    required String label,
    required TextEditingController controller,
    required String currencyValue,
    required Function(String?) onCurrencyChanged,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('$label${isRequired ? ' *' : ''}'),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter ${label.replaceAll(' *', '')}',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) {
                    if (isRequired && (value == null || value.isEmpty)) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonFormField<String>(
                  value: currencyValue,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  items: _currencyOptions.map((currency) {
                    return DropdownMenuItem(
                      value: currency,
                      child: Text(
                        currency,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      onCurrencyChanged(value);
                      _calculateTotal();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter ${label.replaceAll(' *', '')}',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            validator: required
                ? (value) => value?.isEmpty == true ? 'Required' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged, {
    bool required = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down, size: 20),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: onChanged,
            validator: required
                ? (value) => value == null ? 'Required' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    String label,
    TextEditingController controller, {
    bool required = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Select Date',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today, size: 16),
                onPressed: () => _selectDate(controller),
              ),
            ),
            validator: required
                ? (value) => value?.isEmpty == true ? 'Required' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildWIPField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('WIP Project *'),
        TextFormField(
          controller: _wipProjectController,
          style: const TextStyle(fontSize: 14),
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Select WIP Project',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, size: 18),
              onPressed: _showWIPSelectionDialog,
            ),
          ),
          validator: (value) =>
              value?.isEmpty == true ? 'Select WIP project' : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Asset Registration'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        color: Colors.grey[100],
        child: Center(
          child: Container(
            width: 1000,
            height: 650,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Tabs inside the form
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.blue.shade200),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.assignment_ind, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Asset Info',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.attach_money, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Cost Details',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.settings, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Account & Depr',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                      indicatorColor: Colors.blue[800],
                      labelColor: Colors.blue[800],
                      unselectedLabelColor: Colors.grey[600],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Tab 1: Asset Identification
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row 1: Asset Group, Asset Code
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        'Asset Group *',
                                        _selectedAssetGroup,
                                        _assetGroupOptions,
                                        (value) => setState(
                                          () => _selectedAssetGroup = value,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildTextField(
                                        'Asset Code *',
                                        _assetCodeController,
                                      ),
                                    ),
                                  ],
                                ),

                                // Row 2: Acquisition Date, Asset Name
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildDateField(
                                        'Acquisition Date *',
                                        _acquisitionDateController,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildTextField(
                                        'Asset Name *',
                                        _assetNameController,
                                      ),
                                    ),
                                  ],
                                ),

                                // Row 3: Source Type, WIP Project (if visible), Asset Model
                                // This row dynamically adjusts based on WIP visibility
                                _selectedSourceType == 'WIP'
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Source Type (1/3 width)
                                          Expanded(
                                            child: _buildDropdownField(
                                              'Source Type *',
                                              _selectedSourceType,
                                              _sourceTypeOptions,
                                              (value) {
                                                setState(() {
                                                  _selectedSourceType = value;
                                                  if (value == 'WIP') {
                                                    _showWIPSelectionDialog();
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // WIP Project (1/3 width)
                                          Expanded(child: _buildWIPField()),
                                          const SizedBox(width: 12),

                                          // Asset Model (1/3 width)
                                          Expanded(
                                            child: _buildTextField(
                                              'Asset Model',
                                              _assetModelController,
                                              required: false,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Source Type (1/2 width)
                                          Expanded(
                                            child: _buildDropdownField(
                                              'Source Type *',
                                              _selectedSourceType,
                                              _sourceTypeOptions,
                                              (value) {
                                                setState(() {
                                                  _selectedSourceType = value;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),

                                          // Asset Model (1/2 width)
                                          Expanded(
                                            child: _buildTextField(
                                              'Asset Model',
                                              _assetModelController,
                                              required: false,
                                            ),
                                          ),
                                        ],
                                      ),

                                // Row 4: Asset Type, Supplier
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        'Asset Type *',
                                        _selectedAssetType,
                                        _assetTypeOptions,
                                        (value) => setState(
                                          () => _selectedAssetType = value,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildTextField(
                                        'Supplier',
                                        _supplierController,
                                        required: false,
                                      ),
                                    ),
                                  ],
                                ),

                                // Row 5: Asset Status
                                _buildDropdownField(
                                  'Asset Status *',
                                  _selectedAssetStatus,
                                  _assetStatusOptions,
                                  (value) => setState(
                                    () => _selectedAssetStatus = value,
                                  ),
                                ),

                                // Description
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Asset Description'),
                                    TextFormField(
                                      controller: _descriptionController,
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter detailed description',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Tab 2: Cost Details
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Cost Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Row 1: Acquisition Cost, Transportation Cost
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildCostField(
                                        label: 'Acquisition Cost',
                                        controller: _acquisitionCostController,
                                        currencyValue: _acquisitionCostCurrency,
                                        onCurrencyChanged: (value) =>
                                            _acquisitionCostCurrency = value!,
                                        isRequired: true,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildCostField(
                                        label: 'Transportation Cost',
                                        controller:
                                            _transportationFeeController,
                                        currencyValue: _transportationCurrency,
                                        onCurrencyChanged: (value) =>
                                            _transportationCurrency = value!,
                                      ),
                                    ),
                                  ],
                                ),

                                // Row 2: Tax Fees, Other Fees
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildCostField(
                                        label: 'Tax Fees',
                                        controller: _taxFeeController,
                                        currencyValue: _taxCurrency,
                                        onCurrencyChanged: (value) =>
                                            _taxCurrency = value!,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildCostField(
                                        label: 'Other Fees',
                                        controller: _otherFeeController,
                                        currencyValue: _otherCurrency,
                                        onCurrencyChanged: (value) =>
                                            _otherCurrency = value!,
                                      ),
                                    ),
                                  ],
                                ),

                                // Row 3: Additional Cost, Residual Value
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildCostField(
                                        label: 'Additional Cost',
                                        controller: _additionalCostController,
                                        currencyValue: _additionalCurrency,
                                        onCurrencyChanged: (value) =>
                                            _additionalCurrency = value!,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildCostField(
                                        label: 'Residual Value',
                                        controller: _residualValueController,
                                        currencyValue: _residualCurrency,
                                        onCurrencyChanged: (value) =>
                                            _residualCurrency = value!,
                                        isRequired: true,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                // Exchange Rate and Total
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel('Exchange Rate'),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  controller:
                                                      _exchangeRateController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText: 'Rate',
                                                        border:
                                                            OutlineInputBorder(),
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 12,
                                                            ),
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                width: 70,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: Colors.grey.shade50,
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    'MMK',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel('Total Amount (MMK)'),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: Colors.grey.shade50,
                                            ),
                                            child: Text(
                                              _totalAmountController
                                                      .text
                                                      .isEmpty
                                                  ? '0.00'
                                                  : _totalAmountController.text,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
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

                          // Tab 3: Account Details & Depreciation
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Account Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Account Codes in one row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        'Fixed Asset Account *',
                                        _selectedFixedAssetAccount,
                                        _accountCodeOptions,
                                        (value) => setState(
                                          () => _selectedFixedAssetAccount =
                                              value,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownField(
                                        'Depreciation Account *',
                                        _selectedDepreciationAccount,
                                        _accountCodeOptions,
                                        (value) => setState(
                                          () => _selectedDepreciationAccount =
                                              value,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDropdownField(
                                        'Expense Account *',
                                        _selectedExpenseAccount,
                                        _accountCodeOptions,
                                        (value) => setState(
                                          () => _selectedExpenseAccount = value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),
                                const Text(
                                  'Depreciation Configuration',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Depreciation Method and Capitalization Date
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildDropdownField(
                                        'Depreciation Method *',
                                        _selectedDepreciationMethod,
                                        _depreciationMethodOptions,
                                        (value) => setState(
                                          () => _selectedDepreciationMethod =
                                              value,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildDateField(
                                        'Capitalization Date *',
                                        _capitalizationDateController,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Useful Life, Period, and Computation in one row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Useful Life field
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel('Useful Life *'),
                                          TextFormField(
                                            controller: _usefulLifeController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty)
                                                return 'Required';
                                              if (double.tryParse(value) ==
                                                  null)
                                                return 'Invalid number';
                                              return null;
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Useful Period dropdown
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel('Period'),
                                          DropdownButtonFormField<String>(
                                            value: _selectedUsefulLife,
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 12,
                                                  ),
                                            ),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              size: 20,
                                            ),
                                            items: _usefulLifeOptions.map((
                                              life,
                                            ) {
                                              return DropdownMenuItem(
                                                value: life,
                                                child: Text(
                                                  life,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) => setState(
                                              () => _selectedUsefulLife = value,
                                            ),
                                            validator: (value) => value == null
                                                ? 'Required'
                                                : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Computation dropdown
                                    Expanded(
                                      flex: 1,
                                      child: _buildDropdownField(
                                        'Computation *',
                                        _selectedComputation,
                                        _computationOptions,
                                        (value) => setState(
                                          () => _selectedComputation = value,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Depreciation Settings - Two fields in a row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Depreciation Frequency (left column)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel('Depreciation Frequency'),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'Monthly',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: 'Monthly',
                                                  groupValue:
                                                      _depreciationFrequency,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  onChanged: (value) => setState(
                                                    () =>
                                                        _depreciationFrequency =
                                                            value!,
                                                  ),
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'Quarterly',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: 'Quarterly',
                                                  groupValue:
                                                      _depreciationFrequency,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  onChanged: (value) => setState(
                                                    () =>
                                                        _depreciationFrequency =
                                                            value!,
                                                  ),
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'Annually',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: 'Annually',
                                                  groupValue:
                                                      _depreciationFrequency,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  onChanged: (value) => setState(
                                                    () =>
                                                        _depreciationFrequency =
                                                            value!,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Posting Date Rule (right column)
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel('Posting Date Rule'),
                                          const SizedBox(height: 4),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'End of Month',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: 'End of Month',
                                                  groupValue: _postingDateRule,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  onChanged: (value) =>
                                                      setState(
                                                        () => _postingDateRule =
                                                            value!,
                                                      ),
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'Last Working Day',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: 'Last Working Day',
                                                  groupValue: _postingDateRule,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  onChanged: (value) =>
                                                      setState(
                                                        () => _postingDateRule =
                                                            value!,
                                                      ),
                                                ),
                                                RadioListTile<String>(
                                                  title: const Text(
                                                    'Custom',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  value: 'Custom',
                                                  groupValue: _postingDateRule,
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  onChanged: (value) =>
                                                      setState(
                                                        () => _postingDateRule =
                                                            value!,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Buttons
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Clear button for current tab
                        OutlinedButton(
                          onPressed: _currentTabIndex == 0
                              ? _clearTab1
                              : (_currentTabIndex == 1
                                    ? _clearTab2
                                    : _clearTab3),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            side: const BorderSide(
                              color: Colors.orange,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'Clear Tab ${_currentTabIndex + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                        ),

                        // Navigation buttons
                        Row(
                          children: [
                            if (_currentTabIndex > 0)
                              ElevatedButton(
                                onPressed: () {
                                  _navigateToTab(_currentTabIndex - 1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_back,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Previous',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_currentTabIndex > 0 && _currentTabIndex < 2)
                              const SizedBox(width: 8),
                            if (_currentTabIndex < 2)
                              ElevatedButton(
                                onPressed: () {
                                  _navigateToTab(_currentTabIndex + 1);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[800],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Next',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        // Save button (only in Tab 3)
                        if (_currentTabIndex == 2)
                          ElevatedButton(
                            onPressed: _saveForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.save, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'Save',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(
                            width: 80,
                          ), // Placeholder for alignment
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();

    // Remove listeners
    _acquisitionCostController.removeListener(_calculateTotal);
    _transportationFeeController.removeListener(_calculateTotal);
    _taxFeeController.removeListener(_calculateTotal);
    _otherFeeController.removeListener(_calculateTotal);
    _additionalCostController.removeListener(_calculateTotal);
    _exchangeRateController.removeListener(_calculateTotal);

    // Dispose all controllers - Tab 1
    _assetCodeController.dispose();
    _acquisitionDateController.dispose();
    _assetNameController.dispose();
    _assetModelController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    _wipProjectController.dispose();

    // Dispose all controllers - Tab 2
    _acquisitionCostController.dispose();
    _transportationFeeController.dispose();
    _taxFeeController.dispose();
    _otherFeeController.dispose();
    _additionalCostController.dispose();
    _residualValueController.dispose();
    _exchangeRateController.dispose();
    _totalAmountController.dispose();

    // Dispose all controllers - Tab 3
    _capitalizationDateController.dispose();
    _usefulLifeController.dispose();

    super.dispose();
  }
}
