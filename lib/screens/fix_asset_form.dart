import 'package:flutter/material.dart';

class FixAssetForm extends StatefulWidget {
  const FixAssetForm({super.key});

  @override
  State<FixAssetForm> createState() => _FixAssetFormState();
}

class _FixAssetFormState extends State<FixAssetForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _assetCodeController = TextEditingController();
  final TextEditingController _acquisitionDateController =
      TextEditingController();
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _assetModelController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _acquisitionCostController =
      TextEditingController();
  final TextEditingController _transporationFeeController =
      TextEditingController();
  final TextEditingController _taxFeeController = TextEditingController();
  final TextEditingController _otherFeeController = TextEditingController();
  final TextEditingController _additionalCostController =
      TextEditingController();
  final TextEditingController _residualValueController =
      TextEditingController();
  final TextEditingController _homeCurrencyController = TextEditingController(
    text: 'MMK',
  );
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _GLCodeController = TextEditingController();
  final TextEditingController _capitalizationDateController =
      TextEditingController();
  final TextEditingController _usefullifeController = TextEditingController();

  //DropDown
  String? _selectedAssetGroup;
  String? _selectedSourceType;
  String? _selectedAssetType;
  String? _selectedCurrency;
  String? _selectedAssetStatus;
  String? _selectedAccountCode;
  String? _selectedDepreciationMethod;
  String? _selectedUsefulLitfe;
  String? _selectedComputation;

  final List<String> _currencyOptions = ['MMK', 'USD'];
  final List<String> _assetGroupOptions = [
    'Land',
    'Building',
    'Machine',
    'Furniture',
  ];
  final List<String> _sourceTypeOptions = ['WIP', 'Direct'];
  final List<String> _assetTypeOptions = ['Main', 'Component'];
  final List<String> _assetStatusOptions = [
    ' Finished',
    'Ready to use',
    'No depreciation',
  ];
  final List<String> _accountCodeOptions = ['A_001', 'A_002', 'A_003'];
  final List<String> _depreciationMethodOptions = [
    'Straight Line Method',
    'Reducing Method',
  ];
  final List<String> _usefulLifeOptions = ['Year', 'Month', 'Day'];
  final List<String> _computationOptions = ['Yearly', 'Monthly', 'Daily'];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = _currencyOptions.first;
    _selectedAssetGroup = _assetGroupOptions.first;
    _selectedSourceType = _sourceTypeOptions.first;
    _selectedAssetType = _assetTypeOptions.first;
    _selectedAssetStatus = _assetStatusOptions.first;
    _selectedAccountCode = _accountCodeOptions.first;
    _selectedDepreciationMethod = _depreciationMethodOptions.first;
    _selectedUsefulLitfe = _usefulLifeOptions.first;
    _selectedComputation = _computationOptions.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fixed Asset Register Form'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600, minWidth: 500),
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
            child: Form(child: Column(children: [
                  
                ],
              )),
          ),
        ),
      ),
    );
  }
}
