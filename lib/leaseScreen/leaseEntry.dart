// -------------------- Main Form Widget --------------------
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// -------------------- Lease Entry Form --------------------

class LeaseEntryForm extends StatefulWidget {
  final Lease? initialLease; // for editing, optional

  const LeaseEntryForm({Key? key, this.initialLease}) : super(key: key);

  @override
  State<LeaseEntryForm> createState() => _LeaseEntryFormState();
}

class _LeaseEntryFormState extends State<LeaseEntryForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  int _currentTabIndex = 0;

  // ---------- Controllers for Lease (Tab 1) ----------
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _leaseTypeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _leasorNameController = TextEditingController();
  final TextEditingController _contractDateController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _commencementDateController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  // ---------- Controllers for Financial (Tab 2) ----------
  final TextEditingController _contractAmountController =
      TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _downpaymentController = TextEditingController();
  final TextEditingController _otherCostController = TextEditingController();
  final TextEditingController _dismantlingCostController =
      TextEditingController();
  final TextEditingController _leaseTermController = TextEditingController();
  final TextEditingController _leasePeriodController = TextEditingController();
  final TextEditingController _presentValueController = TextEditingController();
  final TextEditingController _discountRateController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController(
    text: '1.0',
  );
  final TextEditingController _paymentFrequencyController =
      TextEditingController();
  final TextEditingController _paymentPeriodController =
      TextEditingController();
  final TextEditingController _computationController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _homeCurrencyController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _changingDateController = TextEditingController();
  final TextEditingController _changingAmountController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // ---------- Amortization Schedule list (Tab 3) ----------
  List<AmortizationSchedule> _schedule = [];

  // ---------- Dropdown options ----------
  final List<String> _leaseTypeOptions = ['Operating', 'Finance', 'Other'];
  final List<String> _statusOptions = [
    'Draft',
    'Active',
    'Expired',
    'Terminated',
  ];
  final List<String> _leasePeriodOptions = ['Months', 'Years'];
  final List<String> _paymentPeriodOptions = [
    'Monthly',
    'Quarterly',
    'Semi-Annually',
    'Annually',
  ];
  final List<String> _computationOptions = [
    'Straight Line',
    'Effective Interest',
    'Other',
  ];
  final List<String> _currencyOptions = ['MMK', 'USD', 'EUR', 'SGD'];
  final List<String> _reasonOptions = ['Renewal', 'Adjustment', 'Termination'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });

    // Load initial data if provided (for editing)
    final initial = widget.initialLease ?? Lease.empty();
    _codeController.text = initial.code;
    _leaseTypeController.text = initial.leaseType;
    _descriptionController.text = initial.description;
    _leasorNameController.text = initial.leasorName;
    _contractDateController.text = initial.contractDate;
    _phoneNoController.text = initial.phoneNo;
    _emailController.text = initial.email;
    _locationController.text = initial.location;
    _commencementDateController.text = initial.commencementDate;
    _expiryDateController.text = initial.expiryDate;
    _statusController.text = initial.status;

    final fin = initial.financial;
    _contractAmountController.text = fin.contractAmount.toString();
    _depositController.text = fin.deposit.toString();
    _downpaymentController.text = fin.downpayment.toString();
    _otherCostController.text = fin.otherCost.toString();
    _dismantlingCostController.text = fin.dismantlingCost.toString();
    _leaseTermController.text = fin.leaseTerm.toString();
    _leasePeriodController.text = fin.leasePeriod;
    _presentValueController.text = fin.presentValue.toString();
    _discountRateController.text = fin.discountRate.toString();
    _exchangeRateController.text = fin.exchangeRate.toString();
    _paymentFrequencyController.text = fin.paymentFrequency.toString();
    _paymentPeriodController.text = fin.paymentPeriod;
    _computationController.text = fin.computation;
    _currencyController.text = fin.currency;
    _homeCurrencyController.text = fin.homeCurrency;
    _reasonController.text = fin.reason;
    _changingDateController.text = fin.changingDate;
    _changingAmountController.text = fin.changingAmount.toString();
    _startDateController.text = fin.startDate;
    _endDateController.text = fin.endDate;

    _schedule = List.from(fin.amortizationSchedule);
  }

  // ---------- Helper: Show date picker ----------
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

  // ---------- Dialog for adding/editing amortization schedule entry ----------
  void _openScheduleEntryDialog({AmortizationSchedule? existing, int? index}) {
    final isEditing = existing != null;
    final dateController = TextEditingController(text: existing?.date ?? '');
    final amountController = TextEditingController(
      text: existing?.payment.toString() ?? '',
    );
    final principalController = TextEditingController(
      text: existing?.principal.toString() ?? '',
    );
    final interestController = TextEditingController(
      text: existing?.interest.toString() ?? '',
    );
    final balanceController = TextEditingController(
      text: existing?.leasePayment.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Schedule Entry' : 'Add Schedule Entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Payment Date
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Payment Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      dateController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(picked);
                    }
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Payment Amount'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: principalController,
                  decoration: InputDecoration(labelText: 'Principal'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: interestController,
                  decoration: InputDecoration(labelText: 'Interest'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: balanceController,
                  decoration: InputDecoration(labelText: 'Balance'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // final newEntry = AmortizationSchedule(
                //   id: existing?.id ?? DateTime.now().millisecondsSinceEpoch,
                //   paymentDate: dateController.text,
                //   paymentAmount: double.tryParse(amountController.text) ?? 0.0,
                //   principal: double.tryParse(principalController.text) ?? 0.0,
                //   interest: double.tryParse(interestController.text) ?? 0.0,
                //   balance: double.tryParse(balanceController.text) ?? 0.0,
                // );
                // setState(() {
                //   if (isEditing && index != null) {
                //     _schedule[index] = newEntry;
                //   } else {
                //     _schedule.add(newEntry);
                //   }
                // });
                // Navigator.pop(ctx);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ---------- Validation per tab ----------
  bool _validateTab1() {
    return _codeController.text.isNotEmpty &&
        _leaseTypeController.text.isNotEmpty &&
        _leasorNameController.text.isNotEmpty &&
        _contractDateController.text.isNotEmpty &&
        _commencementDateController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty &&
        _statusController.text.isNotEmpty;
    // description, phone, email, location are optional
  }

  bool _validateTab2() {
    // Required financial fields: contractAmount, startDate, endDate
    return _contractAmountController.text.isNotEmpty &&
        _startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty;
    // others can be optional or have defaults
  }

  bool _validateTab3() {
    // No strict validation for schedule (can be empty)
    return true;
  }

  // ---------- Navigation with validation ----------
  void _navigateToTab(int targetIndex) {
    bool canNavigate = false;
    if (_currentTabIndex == 0) {
      canNavigate = _validateTab1();
      if (!canNavigate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill all required fields in Lease Info tab'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_currentTabIndex == 1) {
      canNavigate = _validateTab2();
      if (!canNavigate) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill all required fields in Financial Details tab',
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

  // ---------- Clear current tab ----------
  void _clearTab1() {
    _codeController.clear();
    _leaseTypeController.clear();
    _descriptionController.clear();
    _leasorNameController.clear();
    _contractDateController.clear();
    _phoneNoController.clear();
    _emailController.clear();
    _locationController.clear();
    _commencementDateController.clear();
    _expiryDateController.clear();
    _statusController.clear();
  }

  void _clearTab2() {
    _contractAmountController.clear();
    _depositController.clear();
    _downpaymentController.clear();
    _otherCostController.clear();
    _dismantlingCostController.clear();
    _leaseTermController.clear();
    _leasePeriodController.clear();
    _presentValueController.clear();
    _discountRateController.clear();
    _exchangeRateController.text = '1.0';
    _paymentFrequencyController.clear();
    _paymentPeriodController.clear();
    _computationController.clear();
    _currencyController.clear();
    _homeCurrencyController.clear();
    _reasonController.clear();
    _changingDateController.clear();
    _changingAmountController.clear();
    _startDateController.clear();
    _endDateController.clear();
  }

  void _clearTab3() {
    setState(() {
      _schedule.clear();
    });
  }

  // ---------- Save all data ----------
  void _saveForm() {
    if (_validateTab1() && _validateTab2()) {
      // Build Financial object
      final financial = Financial(
        id: widget.initialLease?.financial.id ?? 0,
        contractAmount: double.tryParse(_contractAmountController.text) ?? 0.0,
        deposit: double.tryParse(_depositController.text) ?? 0.0,
        downpayment: double.tryParse(_downpaymentController.text) ?? 0.0,
        otherCost: double.tryParse(_otherCostController.text) ?? 0.0,
        dismantlingCost:
            double.tryParse(_dismantlingCostController.text) ?? 0.0,
        leaseTerm: double.tryParse(_leaseTermController.text) ?? 0.0,
        leasePeriod: _leasePeriodController.text,
        presentValue: double.tryParse(_presentValueController.text) ?? 0.0,
        discountRate: double.tryParse(_discountRateController.text) ?? 0.0,
        exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1.0,
        paymentFrequency:
            double.tryParse(_paymentFrequencyController.text) ?? 0.0,
        paymentPeriod: _paymentPeriodController.text,
        computation: _computationController.text,
        currency: _currencyController.text.isNotEmpty
            ? _currencyController.text
            : 'MMK',
        homeCurrency: _homeCurrencyController.text.isNotEmpty
            ? _homeCurrencyController.text
            : 'MMK',
        reason: _reasonController.text,
        changingDate: _changingDateController.text,
        changingAmount: double.tryParse(_changingAmountController.text) ?? 0.0,
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        amortizationSchedule: _schedule,
      );

      // Build Lease object
      final lease = Lease(
        id: widget.initialLease?.id ?? 0,
        code: _codeController.text,
        leaseType: _leaseTypeController.text,
        description: _descriptionController.text,
        leasorName: _leasorNameController.text,
        contractDate: _contractDateController.text,
        phoneNo: _phoneNoController.text,
        email: _emailController.text,
        location: _locationController.text,
        commencementDate: _commencementDateController.text,
        expiryDate: _expiryDateController.text,
        status: _statusController.text,
        financial: financial,
      );

      // Here you would save to database/API
      // print('Lease saved: ${lease.toJson()}');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lease saved successfully!')));
    } else {
      String errorMessage = 'Please fill all required fields in:\n';
      if (!_validateTab1()) errorMessage += '• Lease Info tab\n';
      if (!_validateTab2()) errorMessage += '• Financial Details tab\n';
      // Tab 3 is optional
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // ---------- UI Helpers (same style as FixAssetForm) ----------
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool required = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(required ? '$label *' : label),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter ${label.toLowerCase()}',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            validator: required
                ? (value) => value == null || value.isEmpty ? 'Required' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    TextEditingController controller,
    List<String> options, {
    bool required = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(required ? '$label *' : label),
          DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down, size: 20),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                controller.text = value ?? '';
              });
            },
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
    bool required = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(required ? '$label *' : label),
          TextFormField(
            controller: controller,
            readOnly: true,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Select date',
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
                ? (value) => value == null || value.isEmpty ? 'Required' : null
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(
    String label,
    TextEditingController controller, {
    bool required = false,
  }) {
    return _buildTextField(
      label,
      controller,
      required: required,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }

  // ---------- Tab Contents ----------
  Widget _buildLeaseInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Row 1: Code and Lease Type
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField('Code', _codeController, required: true),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Lease Type',
                  _leaseTypeController,
                  _leaseTypeOptions,
                  required: true,
                ),
              ),
            ],
          ),
          // Description
          _buildTextField('Description', _descriptionController),
          // Leasor Name (required)
          _buildTextField('Leasor Name', _leasorNameController, required: true),
          // Row 2: Contract Date and Phone No
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDateField(
                  'Contract Date',
                  _contractDateController,
                  required: true,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Phone No',
                  _phoneNoController,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          // Row 3: Email and Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  'Email',
                  _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(width: 12),
              Expanded(child: _buildTextField('Location', _locationController)),
            ],
          ),
          // Row 4: Commencement Date and Expiry Date
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDateField(
                  'Commencement Date',
                  _commencementDateController,
                  required: true,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  'Expiry Date',
                  _expiryDateController,
                  required: true,
                ),
              ),
            ],
          ),
          // Status
          _buildDropdownField(
            'Status',
            _statusController,
            _statusOptions,
            required: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Contract Amount (required)
          _buildNumberField(
            'Contract Amount',
            _contractAmountController,
            required: true,
          ),
          // Row 1: Deposit, Downpayment, Other Cost
          Row(
            children: [
              Expanded(child: _buildNumberField('Deposit', _depositController)),
              SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Downpayment', _downpaymentController),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Other Cost', _otherCostController),
              ),
            ],
          ),
          // Row 2: Dismantling Cost, Lease Term, Lease Period
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  'Dismantling Cost',
                  _dismantlingCostController,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Lease Term', _leaseTermController),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Lease Period',
                  _leasePeriodController,
                  _leasePeriodOptions,
                ),
              ),
            ],
          ),
          // Row 3: Present Value, Discount Rate, Exchange Rate
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  'Present Value',
                  _presentValueController,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Discount Rate',
                  _discountRateController,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Exchange Rate',
                  _exchangeRateController,
                ),
              ),
            ],
          ),
          // Row 4: Payment Frequency, Payment Period, Computation
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  'Payment Frequency',
                  _paymentFrequencyController,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Payment Period',
                  _paymentPeriodController,
                  _paymentPeriodOptions,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Computation',
                  _computationController,
                  _computationOptions,
                ),
              ),
            ],
          ),
          // Row 5: Currency, Home Currency, Reason
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  'Currency',
                  _currencyController,
                  _currencyOptions,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Home Currency',
                  _homeCurrencyController,
                  _currencyOptions,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Reason',
                  _reasonController,
                  _reasonOptions,
                ),
              ),
            ],
          ),
          // Row 6: Changing Date, Changing Amount
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  'Changing Date',
                  _changingDateController,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Changing Amount',
                  _changingAmountController,
                ),
              ),
            ],
          ),
          // Row 7: Start Date (required), End Date (required)
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  'Start Date',
                  _startDateController,
                  required: true,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  'End Date',
                  _endDateController,
                  required: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmortizationTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _schedule.length,
            itemBuilder: (context, index) {
              final item = _schedule[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Payment: ${item.date}'),
                  subtitle: Text(
                    'Amount: ${item.payment}, Principal: ${item.principal}, Interest: ${item.interest}, Balance: ${item.leasePayment}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 18),
                        onPressed: () => _openScheduleEntryDialog(
                          existing: item,
                          index: index,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 18),
                        onPressed: () {
                          setState(() {
                            _schedule.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () => _openScheduleEntryDialog(),
            icon: Icon(Icons.add),
            label: Text('Add Schedule Entry'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lease Registration'),
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
                  // Tabs
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
                              Icon(Icons.info, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Lease Info',
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
                              Text('Financial', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.schedule, size: 16),
                              SizedBox(width: 4),
                              Text('Schedule', style: TextStyle(fontSize: 12)),
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
                          _buildLeaseInfoTab(),
                          _buildFinancialDetailsTab(),
                          _buildAmortizationTab(),
                        ],
                      ),
                    ),
                  ),
                  // Bottom buttons
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
                        // Clear current tab
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
                        // Navigation
                        Row(
                          children: [
                            if (_currentTabIndex > 0)
                              ElevatedButton(
                                onPressed: () =>
                                    _navigateToTab(_currentTabIndex - 1),
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
                                onPressed: () =>
                                    _navigateToTab(_currentTabIndex + 1),
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
                        // Save button (only on last tab)
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
                          ), // placeholder for alignment
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
    // Lease controllers
    _codeController.dispose();
    _leaseTypeController.dispose();
    _descriptionController.dispose();
    _leasorNameController.dispose();
    _contractDateController.dispose();
    _phoneNoController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _commencementDateController.dispose();
    _expiryDateController.dispose();
    _statusController.dispose();
    // Financial controllers
    _contractAmountController.dispose();
    _depositController.dispose();
    _downpaymentController.dispose();
    _otherCostController.dispose();
    _dismantlingCostController.dispose();
    _leaseTermController.dispose();
    _leasePeriodController.dispose();
    _presentValueController.dispose();
    _discountRateController.dispose();
    _exchangeRateController.dispose();
    _paymentFrequencyController.dispose();
    _paymentPeriodController.dispose();
    _computationController.dispose();
    _currencyController.dispose();
    _homeCurrencyController.dispose();
    _reasonController.dispose();
    _changingDateController.dispose();
    _changingAmountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }
}
