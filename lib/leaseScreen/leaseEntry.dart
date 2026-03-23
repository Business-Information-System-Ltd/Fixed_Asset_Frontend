// // -------------------- Lease Entry Form --------------------

// import 'package:fixed_asset_frontend/api/data.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class LeaseEntryForm extends StatefulWidget {
//   final Lease? initialLease; // for editing, optional

//   const LeaseEntryForm({Key? key, this.initialLease}) : super(key: key);

//   @override
//   State<LeaseEntryForm> createState() => _LeaseEntryFormState();
// }

// class _LeaseEntryFormState extends State<LeaseEntryForm>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TabController _tabController;
//   int _currentTabIndex = 0;

//   // ---------- Controllers for Lease (Tab 1) ----------
//   final TextEditingController _codeController = TextEditingController();
//   final TextEditingController _leaseTypeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _leasorNameController = TextEditingController();
//   final TextEditingController _contractDateController = TextEditingController();
//   final TextEditingController _phoneNoController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _commencementDateController =
//       TextEditingController();
//   final TextEditingController _expiryDateController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();

//   // ---------- Controllers for Financial (Tab 2) ----------
//   final TextEditingController _contractAmountController =
//       TextEditingController();
//   final TextEditingController _depositController = TextEditingController();
//   final TextEditingController _downpaymentController = TextEditingController();
//   final TextEditingController _otherCostController = TextEditingController();
//   final TextEditingController _dismantlingCostController =
//       TextEditingController();
//   final TextEditingController _leaseTermController = TextEditingController();
//   final TextEditingController _leasePeriodController = TextEditingController();
//   final TextEditingController _presentValueController = TextEditingController();
//   final TextEditingController _discountRateController = TextEditingController();
//   final TextEditingController _exchangeRateController = TextEditingController(
//     text: '1.0',
//   );
//   final TextEditingController _paymentFrequencyController =
//       TextEditingController();
//   final TextEditingController _paymentPeriodController =
//       TextEditingController();
//   final TextEditingController _computationController = TextEditingController();
//   final TextEditingController _currencyController = TextEditingController();
//   final TextEditingController _homeCurrencyController = TextEditingController(
//     text: 'MMK',
//   );
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _changingDateController = TextEditingController();
//   final TextEditingController _changingAmountController =
//       TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _totalamountController = TextEditingController();

//   // ---------- Dropdown options ----------
//   final List<String> _leaseTypeOptions = [
//     'Building',
//     'Land',
//     'Office Equipment',
//     'Vehicle',
//     'Other',
//   ];
//   final List<String> _statusOptions = [
//     'Active',
//     'Completed',
//     'Amendment',
//     'Cancelled',
//   ];
//   final List<String> _leasePeriodOptions = ['Months', 'Years'];
//   final List<String> _paymentPeriodOptions = [
//     'Monthly',
//     'Quarterly',
//     'Annually',
//   ];
//   final List<String> _computationOptions = ['Monthly', 'Yearly'];
//   final List<String> _currencyOptions = ['MMK', 'USD', 'EUR', 'SGD'];
//   final List<String> _reasonOptions = ['Renewal', 'Adjustment', 'Termination'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _currentTabIndex = _tabController.index;
//       });
//     });

//     // Load initial data if provided (for editing)
//     final initial = widget.initialLease ?? Lease.empty();
//     _codeController.text = initial.code;
//     _leaseTypeController.text = initial.leaseType;
//     _descriptionController.text = initial.description;
//     _leasorNameController.text = initial.leasorName;
//     _contractDateController.text = initial.contractDate;
//     _phoneNoController.text = initial.phoneNo;
//     _emailController.text = initial.email;
//     _locationController.text = initial.location;
//     _commencementDateController.text = initial.commencementDate;
//     _expiryDateController.text = initial.expiryDate;

//     final fin = initial.financial;
//     _contractAmountController.text = fin.contractAmount.toString();
//     _depositController.text = fin.deposit.toString();
//     _downpaymentController.text = fin.downpayment.toString();
//     _otherCostController.text = fin.otherCost.toString();
//     _dismantlingCostController.text = fin.dismantlingCost.toString();
//     _leaseTermController.text = fin.leaseTerm.toString();
//     _leasePeriodController.text = fin.leasePeriod;
//     _presentValueController.text = fin.presentValue.toString();
//     _discountRateController.text = fin.discountRate.toString();
//     _exchangeRateController.text = fin.exchangeRate.toString();
//     _paymentFrequencyController.text = fin.paymentFrequency.toString();
//     _paymentPeriodController.text = fin.paymentPeriod;
//     _computationController.text = fin.computation;
//     _currencyController.text = fin.currency;
//     _homeCurrencyController.text = fin.homeCurrency;
//     _reasonController.text = fin.reason;
//     _changingDateController.text = fin.changingDate;
//     _changingAmountController.text = fin.changingAmount.toString();
//     _startDateController.text = fin.startDate;
//     _endDateController.text = fin.endDate;
//     // amortizationSchedule is no longer loaded
//   }

//   // ---------- Helper: Show date picker ----------
//   Future<void> _selectDate(TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   // ---------- Validation per tab ----------
//   bool _validateTab1() {
//     return _codeController.text.isNotEmpty &&
//         _leaseTypeController.text.isNotEmpty &&
//         _leasorNameController.text.isNotEmpty &&
//         _contractDateController.text.isNotEmpty &&
//         _commencementDateController.text.isNotEmpty &&
//         _expiryDateController.text.isNotEmpty &&
//         _statusController.text.isNotEmpty;
//   }

//   bool _validateTab2() {
//     return _contractAmountController.text.isNotEmpty &&
//         _startDateController.text.isNotEmpty &&
//         _endDateController.text.isNotEmpty;
//   }

//   // ---------- Navigation with validation ----------
//   void _navigateToTab(int targetIndex) {
//     bool canNavigate = false;
//     if (_currentTabIndex == 0) {
//       canNavigate = _validateTab1();
//       if (!canNavigate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Please fill all required fields in Lease Info tab'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else if (_currentTabIndex == 1) {
//       canNavigate = _validateTab2();
//       if (!canNavigate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Please fill all required fields in Financial Details tab',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       canNavigate = true; // not reached
//     }

//     if (canNavigate) {
//       _tabController.animateTo(targetIndex);
//     }
//   }

//   // ---------- Clear current tab ----------
//   void _clearTab1() {
//     _codeController.clear();
//     _leaseTypeController.clear();
//     _descriptionController.clear();
//     _leasorNameController.clear();
//     _contractDateController.clear();
//     _phoneNoController.clear();
//     _emailController.clear();
//     _locationController.clear();
//     _commencementDateController.clear();
//     _expiryDateController.clear();
//     _statusController.clear();
//   }

//   void _clearTab2() {
//     _contractAmountController.clear();
//     _depositController.clear();
//     _downpaymentController.clear();
//     _otherCostController.clear();
//     _dismantlingCostController.clear();
//     _leaseTermController.clear();
//     _leasePeriodController.clear();
//     _presentValueController.clear();
//     _discountRateController.clear();
//     _exchangeRateController.text = '1.0';
//     _paymentFrequencyController.clear();
//     _paymentPeriodController.clear();
//     _computationController.clear();
//     _currencyController.clear();
//     _homeCurrencyController.clear();
//     _reasonController.clear();
//     _changingDateController.clear();
//     _changingAmountController.clear();
//     _startDateController.clear();
//     _endDateController.clear();
//   }

//   // ---------- Save all data ----------
//   void _saveForm() {
//     if (_validateTab1() && _validateTab2()) {
//       // Build Financial object (amortizationSchedule is empty list)
//       final financial = Financial(
//         id: widget.initialLease?.financial.id ?? 0,
//         contractAmount: double.tryParse(_contractAmountController.text) ?? 0.0,
//         deposit: double.tryParse(_depositController.text) ?? 0.0,
//         downpayment: double.tryParse(_downpaymentController.text) ?? 0.0,
//         otherCost: double.tryParse(_otherCostController.text) ?? 0.0,
//         dismantlingCost:
//             double.tryParse(_dismantlingCostController.text) ?? 0.0,
//         leaseTerm: double.tryParse(_leaseTermController.text) ?? 0.0,
//         leasePeriod: _leasePeriodController.text,
//         presentValue: double.tryParse(_presentValueController.text) ?? 0.0,
//         discountRate: double.tryParse(_discountRateController.text) ?? 0.0,
//         exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1.0,
//         paymentFrequency:
//             double.tryParse(_paymentFrequencyController.text) ?? 0.0,
//         paymentPeriod: _paymentPeriodController.text,
//         computation: _computationController.text,
//         currency: _currencyController.text.isNotEmpty
//             ? _currencyController.text
//             : 'MMK',
//         homeCurrency: _homeCurrencyController.text.isNotEmpty
//             ? _homeCurrencyController.text
//             : 'MMK',
//         reason: _reasonController.text,
//         changingDate: _changingDateController.text,
//         changingAmount: double.tryParse(_changingAmountController.text) ?? 0.0,
//         startDate: _startDateController.text,
//         endDate: _endDateController.text,
//         amortizationSchedule: [],
//       );

//       // Build Lease object
//       final lease = Lease(
//         id: widget.initialLease?.id ?? 0,
//         code: _codeController.text,
//         leaseType: _leaseTypeController.text,
//         description: _descriptionController.text,
//         leasorName: _leasorNameController.text,
//         contractDate: _contractDateController.text,
//         phoneNo: _phoneNoController.text,
//         email: _emailController.text,
//         location: _locationController.text,
//         commencementDate: _commencementDateController.text,
//         expiryDate: _expiryDateController.text,
//         status: 'Active',
//         financial: financial,
//       );

//       // Here you would save to database/API

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Lease saved successfully!')));
//     } else {
//       String errorMessage = 'Please fill all required fields in:\n';
//       if (!_validateTab1()) errorMessage += '• Lease Info tab\n';
//       if (!_validateTab2()) errorMessage += '• Financial Details tab\n';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   // ---------- UI Helpers (same as before) ----------
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Enter ${label.toLowerCase()}',
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//             ),
//             validator: required
//                 ? (value) => value == null || value.isEmpty ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownField(
//     String label,
//     TextEditingController controller,
//     List<String> options, {
//     bool required = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           DropdownButtonFormField<String>(
//             value: controller.text.isNotEmpty ? controller.text : null,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//             ),
//             icon: const Icon(Icons.arrow_drop_down, size: 20),
//             items: options.map((option) {
//               return DropdownMenuItem(
//                 value: option,
//                 child: Text(option, style: const TextStyle(fontSize: 14)),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 controller.text = value ?? '';
//               });
//             },
//             validator: required
//                 ? (value) => value == null ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           TextFormField(
//             controller: controller,
//             readOnly: true,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Select date',
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.calendar_today, size: 16),
//                 onPressed: () => _selectDate(controller),
//               ),
//             ),
//             validator: required
//                 ? (value) => value == null || value.isEmpty ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNumberField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//   }) {
//     return _buildTextField(
//       label,
//       controller,
//       required: required,
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//     );
//   }

//   // ---------- Tab Contents ----------
//   Widget _buildLeaseInfoTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField('Code', _codeController, required: true),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Lease Type',
//                   _leaseTypeController,
//                   _leaseTypeOptions,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//           _buildTextField('Description', _descriptionController),
//           _buildTextField('Leasor Name', _leasorNameController, required: true),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField(
//                   'Email',
//                   _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildTextField(
//                   'Phone No',
//                   _phoneNoController,
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildTextField('Location', _locationController)),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateField(
//                   'Contract Date',
//                   _contractDateController,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   'Commencement Date',
//                   _commencementDateController,
//                   required: true,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateField(
//                   'Expiry Date',
//                   _expiryDateController,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFinancialDetailsTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: _buildNumberField(
//                   'Contract Amount',
//                   _contractAmountController,
//                   required: true,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Currency',
//                   _currencyController,
//                   _currencyOptions,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(child: _buildNumberField('Deposit', _depositController)),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Downpayment', _downpaymentController),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Other Cost', _otherCostController),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildNumberField(
//                   'Dismantling Cost',
//                   _dismantlingCostController,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Discount Rate',
//                   _discountRateController,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Computation',
//                   _computationController,
//                   _computationOptions,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildNumberField(
//                   'Payment Frequency',
//                   _paymentFrequencyController,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Payment Period',
//                   _paymentPeriodController,
//                   _paymentPeriodOptions,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Lease Term', _leaseTermController),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Lease Period',
//                   _leasePeriodController,
//                   _leasePeriodOptions,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildTextField(
//                   'Home Currency',
//                   _homeCurrencyController,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Exchange Rate',
//                   _exchangeRateController,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Total Amount',
//                   _totalamountController,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   'Changing Date',
//                   _changingDateController,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Changing Amount',
//                   _changingAmountController,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lease Registration'),
//         centerTitle: true,
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//         elevation: 2,
//       ),
//       body: Container(
//         color: Colors.grey[100],
//         child: Center(
//           child: Container(
//             width: 1000,
//             height: 650,
//             margin: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Tabs
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       border: Border(
//                         bottom: BorderSide(color: Colors.blue.shade200),
//                       ),
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       tabs: const [
//                         Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.info, size: 16),
//                               SizedBox(width: 4),
//                               Text(
//                                 'Lease Info',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.attach_money, size: 16),
//                               SizedBox(width: 4),
//                               Text('Financial', style: TextStyle(fontSize: 12)),
//                             ],
//                           ),
//                         ),
//                       ],
//                       indicatorColor: Colors.blue[800],
//                       labelColor: Colors.blue[800],
//                       unselectedLabelColor: Colors.grey[600],
//                     ),
//                   ),
//                   // Tab content
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: [
//                           _buildLeaseInfoTab(),
//                           _buildFinancialDetailsTab(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Bottom buttons
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       border: Border(
//                         top: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Clear current tab
//                         OutlinedButton(
//                           onPressed: _currentTabIndex == 0
//                               ? _clearTab1
//                               : _clearTab2,
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 10,
//                             ),
//                             side: const BorderSide(
//                               color: Colors.orange,
//                               width: 1,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           child: Text(
//                             'Clear Tab ${_currentTabIndex + 1}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ),
//                         // Navigation
//                         Row(
//                           children: [
//                             if (_currentTabIndex > 0)
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _navigateToTab(_currentTabIndex - 1),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey[600],
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_back,
//                                       size: 14,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       'Previous',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             if (_currentTabIndex > 0 && _currentTabIndex < 1)
//                               const SizedBox(width: 8),
//                             if (_currentTabIndex < 1)
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _navigateToTab(_currentTabIndex + 1),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue[800],
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Text(
//                                       'Next',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Icon(
//                                       Icons.arrow_forward,
//                                       size: 14,
//                                       color: Colors.white,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                         // Save button (only on last tab = Financial)
//                         if (_currentTabIndex == 1)
//                           ElevatedButton(
//                             onPressed: _saveForm,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green[700],
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             child: const Row(
//                               children: [
//                                 Icon(Icons.save, size: 14, color: Colors.white),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   'Save',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         else
//                           const SizedBox(
//                             width: 80,
//                           ), // placeholder for alignment
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     // Lease controllers
//     _codeController.dispose();
//     _leaseTypeController.dispose();
//     _descriptionController.dispose();
//     _leasorNameController.dispose();
//     _contractDateController.dispose();
//     _phoneNoController.dispose();
//     _emailController.dispose();
//     _locationController.dispose();
//     _commencementDateController.dispose();
//     _expiryDateController.dispose();
//     _statusController.dispose();
//     // Financial controllers
//     _contractAmountController.dispose();
//     _depositController.dispose();
//     _downpaymentController.dispose();
//     _otherCostController.dispose();
//     _dismantlingCostController.dispose();
//     _leaseTermController.dispose();
//     _leasePeriodController.dispose();
//     _presentValueController.dispose();
//     _discountRateController.dispose();
//     _exchangeRateController.dispose();
//     _paymentFrequencyController.dispose();
//     _paymentPeriodController.dispose();
//     _computationController.dispose();
//     _currencyController.dispose();
//     _homeCurrencyController.dispose();
//     _reasonController.dispose();
//     _changingDateController.dispose();
//     _changingAmountController.dispose();
//     _startDateController.dispose();
//     _endDateController.dispose();
//     super.dispose();
//   }
// }

// import 'package:fixed_asset_frontend/api/data.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class LeaseEntryForm extends StatefulWidget {
//   final Lease? initialLease; // for editing, optional

//   const LeaseEntryForm({Key? key, this.initialLease}) : super(key: key);

//   @override
//   State<LeaseEntryForm> createState() => _LeaseEntryFormState();
// }

// class _LeaseEntryFormState extends State<LeaseEntryForm>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TabController _tabController;
//   int _currentTabIndex = 0;

//   // ---------- Controllers for Lease (Tab 1) ----------
//   final TextEditingController _codeController = TextEditingController();
//   final TextEditingController _leaseTypeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _leasorNameController = TextEditingController();
//   final TextEditingController _contractDateController = TextEditingController();
//   final TextEditingController _phoneNoController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _commencementDateController =
//       TextEditingController();
//   final TextEditingController _expiryDateController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();

//   // ---------- Controllers for Financial (Tab 2) ----------
//   final TextEditingController _contractAmountController =
//       TextEditingController();
//   final TextEditingController _depositController = TextEditingController();
//   final TextEditingController _downpaymentController = TextEditingController();
//   final TextEditingController _otherCostController = TextEditingController();
//   final TextEditingController _dismantlingCostController =
//       TextEditingController();
//   final TextEditingController _leaseTermController = TextEditingController();
//   final TextEditingController _leasePeriodController = TextEditingController();
//   final TextEditingController _presentValueController = TextEditingController();
//   final TextEditingController _discountRateController = TextEditingController();
//   final TextEditingController _exchangeRateController = TextEditingController(
//     text: '1.0',
//   );
//   final TextEditingController _paymentFrequencyController =
//       TextEditingController();
//   final TextEditingController _paymentPeriodController =
//       TextEditingController();
//   final TextEditingController _computationController = TextEditingController();
//   final TextEditingController _currencyController = TextEditingController();
//   final TextEditingController _homeCurrencyController = TextEditingController(
//     text: 'MMK',
//   );
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _changingDateController = TextEditingController();
//   final TextEditingController _changingAmountController =
//       TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _totalamountController = TextEditingController();

//   // ---------- Dropdown options ----------
//   final List<String> _leaseTypeOptions = [
//     'Building',
//     'Land',
//     'Office Equipment',
//     'Vehicle',
//     'Other',
//   ];
//   final List<String> _statusOptions = [
//     'Active',
//     'Completed',
//     'Amendment',
//     'Cancelled',
//   ];
//   final List<String> _leasePeriodOptions = ['Months', 'Years'];
//   final List<String> _paymentPeriodOptions = [
//     'Monthly',
//     'Quarterly',
//     'Annually',
//   ];
//   final List<String> _computationOptions = ['Monthly', 'Yearly'];
//   final List<String> _currencyOptions = ['MMK', 'USD', 'EUR', 'SGD'];
//   final List<String> _reasonOptions = ['Renewal', 'Adjustment', 'Termination'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _currentTabIndex = _tabController.index;
//       });
//     });

//     // Load initial data if provided (for editing)
//     final initial = widget.initialLease ?? Lease.empty();
//     _codeController.text = initial.code;
//     _leaseTypeController.text = initial.leaseType;
//     _descriptionController.text = initial.description;
//     _leasorNameController.text = initial.leasorName;
//     _contractDateController.text = initial.contractDate;
//     _phoneNoController.text = initial.phoneNo;
//     _emailController.text = initial.email;
//     _locationController.text = initial.location;
//     _commencementDateController.text = initial.commencementDate;
//     _expiryDateController.text = initial.expiryDate;

//     final fin = initial.financial;
//     _contractAmountController.text = fin.contractAmount.toString();
//     _depositController.text = fin.deposit.toString();
//     _downpaymentController.text = fin.downpayment.toString();
//     _otherCostController.text = fin.otherCost.toString();
//     _dismantlingCostController.text = fin.dismantlingCost.toString();
//     _leaseTermController.text = fin.leaseTerm.toString();
//     _leasePeriodController.text = fin.leasePeriod;
//     _presentValueController.text = fin.presentValue.toString();
//     _discountRateController.text = fin.discountRate.toString();
//     _exchangeRateController.text = fin.exchangeRate.toString();
//     _paymentFrequencyController.text = fin.paymentFrequency.toString();
//     _paymentPeriodController.text = fin.paymentPeriod;
//     _computationController.text = fin.computation;
//     _currencyController.text = fin.currency;
//     _homeCurrencyController.text = fin.homeCurrency;
//     _reasonController.text = fin.reason;
//     _changingDateController.text = fin.changingDate;
//     _changingAmountController.text = fin.changingAmount.toString();
//     _startDateController.text = fin.startDate;
//     _endDateController.text = fin.endDate;
//     // amortizationSchedule is no longer loaded
//   }

//   // ---------- Helper: Show date picker ----------
//   Future<void> _selectDate(TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   // ---------- Validation per tab ----------
//   bool _validateTab1() {
//     return _codeController.text.isNotEmpty &&
//         _leaseTypeController.text.isNotEmpty &&
//         _leasorNameController.text.isNotEmpty &&
//         _contractDateController.text.isNotEmpty &&
//         _commencementDateController.text.isNotEmpty &&
//         _expiryDateController.text.isNotEmpty &&
//         _statusController.text.isNotEmpty;
//   }

//   bool _validateTab2() {
//     return _contractAmountController.text.isNotEmpty &&
//         _startDateController.text.isNotEmpty &&
//         _endDateController.text.isNotEmpty;
//   }

//   // ---------- Navigation with validation ----------
//   void _navigateToTab(int targetIndex) {
//     bool canNavigate = false;
//     if (_currentTabIndex == 0) {
//       canNavigate = _validateTab1();
//       if (!canNavigate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Please fill all required fields in Lease Info tab'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else if (_currentTabIndex == 1) {
//       canNavigate = _validateTab2();
//       if (!canNavigate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Please fill all required fields in Financial Details tab',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       canNavigate = true; // not reached
//     }

//     if (canNavigate) {
//       _tabController.animateTo(targetIndex);
//     }
//   }

//   // ---------- Clear current tab ----------
//   void _clearTab1() {
//     _codeController.clear();
//     _leaseTypeController.clear();
//     _descriptionController.clear();
//     _leasorNameController.clear();
//     _contractDateController.clear();
//     _phoneNoController.clear();
//     _emailController.clear();
//     _locationController.clear();
//     _commencementDateController.clear();
//     _expiryDateController.clear();
//     _statusController.clear();
//   }

//   void _clearTab2() {
//     _contractAmountController.clear();
//     _depositController.clear();
//     _downpaymentController.clear();
//     _otherCostController.clear();
//     _dismantlingCostController.clear();
//     _leaseTermController.clear();
//     _leasePeriodController.clear();
//     _presentValueController.clear();
//     _discountRateController.clear();
//     _exchangeRateController.text = '1.0';
//     _paymentFrequencyController.clear();
//     _paymentPeriodController.clear();
//     _computationController.clear();
//     _currencyController.clear();
//     _homeCurrencyController.clear();
//     _reasonController.clear();
//     _changingDateController.clear();
//     _changingAmountController.clear();
//     _startDateController.clear();
//     _endDateController.clear();
//   }

//   // ---------- Save all data ----------
//   void _saveForm() {
//     if (_validateTab1() && _validateTab2()) {
//       // Build Financial object (amortizationSchedule is empty list)
//       final financial = Financial(
//         id: widget.initialLease?.financial.id ?? 0,
//         contractAmount: double.tryParse(_contractAmountController.text) ?? 0.0,
//         deposit: double.tryParse(_depositController.text) ?? 0.0,
//         downpayment: double.tryParse(_downpaymentController.text) ?? 0.0,
//         otherCost: double.tryParse(_otherCostController.text) ?? 0.0,
//         dismantlingCost:
//             double.tryParse(_dismantlingCostController.text) ?? 0.0,
//         leaseTerm: double.tryParse(_leaseTermController.text) ?? 0.0,
//         leasePeriod: _leasePeriodController.text,
//         presentValue: double.tryParse(_presentValueController.text) ?? 0.0,
//         discountRate: double.tryParse(_discountRateController.text) ?? 0.0,
//         exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1.0,
//         paymentFrequency:
//             double.tryParse(_paymentFrequencyController.text) ?? 0.0,
//         paymentPeriod: _paymentPeriodController.text,
//         computation: _computationController.text,
//         currency: _currencyController.text.isNotEmpty
//             ? _currencyController.text
//             : 'MMK',
//         homeCurrency: _homeCurrencyController.text.isNotEmpty
//             ? _homeCurrencyController.text
//             : 'MMK',
//         reason: _reasonController.text,
//         changingDate: _changingDateController.text,
//         changingAmount: double.tryParse(_changingAmountController.text) ?? 0.0,
//         startDate: _startDateController.text,
//         endDate: _endDateController.text,
//         amortizationSchedule: [],
//       );

//       // Build Lease object
//       final lease = Lease(
//         id: widget.initialLease?.id ?? 0,
//         code: _codeController.text,
//         leaseType: _leaseTypeController.text,
//         description: _descriptionController.text,
//         leasorName: _leasorNameController.text,
//         contractDate: _contractDateController.text,
//         phoneNo: _phoneNoController.text,
//         email: _emailController.text,
//         location: _locationController.text,
//         commencementDate: _commencementDateController.text,
//         expiryDate: _expiryDateController.text,
//         status: 'Active',
//         financial: financial,
//       );

//       // Here you would save to database/API

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Lease saved successfully!')));
//     } else {
//       String errorMessage = 'Please fill all required fields in:\n';
//       if (!_validateTab1()) errorMessage += '• Lease Info tab\n';
//       if (!_validateTab2()) errorMessage += '• Financial Details tab\n';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   // ---------- UI Helpers (same as before) ----------
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Enter ${label.toLowerCase()}',
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//             ),
//             validator: required
//                 ? (value) => value == null || value.isEmpty ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownField(
//     String label,
//     TextEditingController controller,
//     List<String> options, {
//     bool required = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           DropdownButtonFormField<String>(
//             value: controller.text.isNotEmpty ? controller.text : null,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//             ),
//             icon: const Icon(Icons.arrow_drop_down, size: 20),
//             items: options.map((option) {
//               return DropdownMenuItem(
//                 value: option,
//                 child: Text(option, style: const TextStyle(fontSize: 14)),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 controller.text = value ?? '';
//               });
//             },
//             validator: required
//                 ? (value) => value == null ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           TextFormField(
//             controller: controller,
//             readOnly: true,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Select date',
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.calendar_today, size: 16),
//                 onPressed: () => _selectDate(controller),
//               ),
//             ),
//             validator: required
//                 ? (value) => value == null || value.isEmpty ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNumberField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//   }) {
//     return _buildTextField(
//       label,
//       controller,
//       required: required,
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//     );
//   }

//   // ---------- Tab Contents ----------
//   Widget _buildLeaseInfoTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField('Code', _codeController, required: true),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Lease Type',
//                   _leaseTypeController,
//                   _leaseTypeOptions,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//           _buildTextField('Description', _descriptionController),
//           _buildTextField('Leasor Name', _leasorNameController, required: true),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField(
//                   'Email',
//                   _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildTextField(
//                   'Phone No',
//                   _phoneNoController,
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildTextField('Location', _locationController)),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateField(
//                   'Contract Date',
//                   _contractDateController,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   'Commencement Date',
//                   _commencementDateController,
//                   required: true,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateField(
//                   'Expiry Date',
//                   _expiryDateController,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ========== MODIFIED FINANCIAL TAB ==========
//   Widget _buildFinancialDetailsTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Row 1: Contract Amount (flex 3), Currency (flex 1), Dismantling Cost (flex 3), Other Cost (flex 3)
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: _buildNumberField(
//                   'Contract Amount',
//                   _contractAmountController,
//                   required: true,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 1, // smaller width for currency
//                 child: _buildDropdownField(
//                   'Currency',
//                   _currencyController,
//                   _currencyOptions,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 3,
//                 child: _buildNumberField(
//                   'Dismantling Cost',
//                   _dismantlingCostController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 3,
//                 child: _buildNumberField('Other Cost', _otherCostController),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 2: Deposit, Downpayment, Total Amount
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildNumberField('Deposit', _depositController)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Downpayment', _downpaymentController),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Total Amount',
//                   _totalamountController,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 3: Home Currency, Exchange Rate, Discount Rate, Computation
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField(
//                   'Home Currency',
//                   _homeCurrencyController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Exchange Rate',
//                   _exchangeRateController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Discount Rate',
//                   _discountRateController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Computation',
//                   _computationController,
//                   _computationOptions,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 4: Payment Frequency, Payment Period, Lease Term, Lease Period
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildNumberField(
//                   'Payment Frequency',
//                   _paymentFrequencyController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Payment Period',
//                   _paymentPeriodController,
//                   _paymentPeriodOptions,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Lease Term', _leaseTermController),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Lease Period',
//                   _leasePeriodController,
//                   _leasePeriodOptions,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 5: Changing Date, Changing Amount
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   'Changing Date',
//                   _changingDateController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Changing Amount',
//                   _changingAmountController,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lease Registration'),
//         centerTitle: true,
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//         elevation: 2,
//       ),
//       body: Container(
//         color: Colors.grey[100],
//         child: Center(
//           child: Container(
//             width: 1000,
//             height: 650,
//             margin: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Tabs
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       border: Border(
//                         bottom: BorderSide(color: Colors.blue.shade200),
//                       ),
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       tabs: const [
//                         Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.info, size: 16),
//                               SizedBox(width: 4),
//                               Text(
//                                 'Lease Info',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.attach_money, size: 16),
//                               SizedBox(width: 4),
//                               Text('Financial', style: TextStyle(fontSize: 12)),
//                             ],
//                           ),
//                         ),
//                       ],
//                       indicatorColor: Colors.blue[800],
//                       labelColor: Colors.blue[800],
//                       unselectedLabelColor: Colors.grey[600],
//                     ),
//                   ),
//                   // Tab content
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: [
//                           _buildLeaseInfoTab(),
//                           _buildFinancialDetailsTab(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Bottom buttons
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       border: Border(
//                         top: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Clear current tab
//                         OutlinedButton(
//                           onPressed: _currentTabIndex == 0
//                               ? _clearTab1
//                               : _clearTab2,
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 10,
//                             ),
//                             side: const BorderSide(
//                               color: Colors.orange,
//                               width: 1,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           child: Text(
//                             'Clear Tab ${_currentTabIndex + 1}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ),
//                         // Navigation
//                         Row(
//                           children: [
//                             if (_currentTabIndex > 0)
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _navigateToTab(_currentTabIndex - 1),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey[600],
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_back,
//                                       size: 14,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       'Previous',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             if (_currentTabIndex > 0 && _currentTabIndex < 1)
//                               const SizedBox(width: 8),
//                             if (_currentTabIndex < 1)
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _navigateToTab(_currentTabIndex + 1),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue[800],
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Text(
//                                       'Next',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Icon(
//                                       Icons.arrow_forward,
//                                       size: 14,
//                                       color: Colors.white,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                         // Save button (only on last tab = Financial)
//                         if (_currentTabIndex == 1)
//                           ElevatedButton(
//                             onPressed: _saveForm,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green[700],
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             child: const Row(
//                               children: [
//                                 Icon(Icons.save, size: 14, color: Colors.white),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   'Save',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         else
//                           const SizedBox(
//                             width: 80,
//                           ), // placeholder for alignment
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     // Lease controllers
//     _codeController.dispose();
//     _leaseTypeController.dispose();
//     _descriptionController.dispose();
//     _leasorNameController.dispose();
//     _contractDateController.dispose();
//     _phoneNoController.dispose();
//     _emailController.dispose();
//     _locationController.dispose();
//     _commencementDateController.dispose();
//     _expiryDateController.dispose();
//     _statusController.dispose();
//     // Financial controllers
//     _contractAmountController.dispose();
//     _depositController.dispose();
//     _downpaymentController.dispose();
//     _otherCostController.dispose();
//     _dismantlingCostController.dispose();
//     _leaseTermController.dispose();
//     _leasePeriodController.dispose();
//     _presentValueController.dispose();
//     _discountRateController.dispose();
//     _exchangeRateController.dispose();
//     _paymentFrequencyController.dispose();
//     _paymentPeriodController.dispose();
//     _computationController.dispose();
//     _currencyController.dispose();
//     _homeCurrencyController.dispose();
//     _reasonController.dispose();
//     _changingDateController.dispose();
//     _changingAmountController.dispose();
//     _startDateController.dispose();
//     _endDateController.dispose();
//     super.dispose();
//   }
// }

// import 'package:fixed_asset_frontend/api/api_service.dart';
// import 'package:fixed_asset_frontend/api/data.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class LeaseEntryForm extends StatefulWidget {
//   final Lease? initialLease; // for editing, optional

//   const LeaseEntryForm({Key? key, this.initialLease}) : super(key: key);

//   @override
//   State<LeaseEntryForm> createState() => _LeaseEntryFormState();
// }

// class _LeaseEntryFormState extends State<LeaseEntryForm>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   late TabController _tabController;
//   int _currentTabIndex = 0;
//   bool _isSaving = false; // NEW: loading flag

//   // ---------- Controllers for Lease (Tab 1) ----------
//   final TextEditingController _codeController = TextEditingController();
//   final TextEditingController _leaseTypeController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _leasorNameController = TextEditingController();
//   final TextEditingController _contractDateController = TextEditingController();
//   final TextEditingController _phoneNoController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _commencementDateController =
//       TextEditingController();
//   final TextEditingController _expiryDateController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();

//   // ---------- Controllers for Financial (Tab 2) ----------
//   final TextEditingController _contractAmountController =
//       TextEditingController();
//   final TextEditingController _depositController = TextEditingController();
//   final TextEditingController _downpaymentController = TextEditingController();
//   final TextEditingController _otherCostController = TextEditingController();
//   final TextEditingController _dismantlingCostController =
//       TextEditingController();
//   final TextEditingController _leaseTermController = TextEditingController();
//   final TextEditingController _leasePeriodController = TextEditingController();
//   final TextEditingController _presentValueController = TextEditingController();
//   final TextEditingController _discountRateController = TextEditingController();
//   final TextEditingController _exchangeRateController = TextEditingController(
//     text: '1.0',
//   );
//   final TextEditingController _paymentFrequencyController =
//       TextEditingController();
//   final TextEditingController _paymentPeriodController =
//       TextEditingController();
//   final TextEditingController _computationController = TextEditingController();
//   final TextEditingController _currencyController = TextEditingController();
//   final TextEditingController _homeCurrencyController = TextEditingController(
//     text: 'MMK',
//   );
//   final TextEditingController _reasonController = TextEditingController();
//   final TextEditingController _changingDateController = TextEditingController();
//   final TextEditingController _changingAmountController =
//       TextEditingController();
//   final TextEditingController _startDateController = TextEditingController();
//   final TextEditingController _endDateController = TextEditingController();
//   final TextEditingController _totalamountController = TextEditingController();

//   // ---------- Dropdown options ----------
//   final List<String> _leaseTypeOptions = [
//     'Building',
//     'Land',
//     'Office Equipment',
//     'Vehicle',
//     'Other',
//   ];
//   final List<String> _statusOptions = [
//     'Active',
//     'Completed',
//     'Amendment',
//     'Cancelled',
//   ];
//   final List<String> _leasePeriodOptions = ['Month', 'Year', 'Quaterly'];
//   final List<String> _paymentPeriodOptions = [
//     'Monthly',
//     'Quarterly',
//     'Annually',
//   ];
//   final List<String> _computationOptions = ['Monthly', 'Yearly'];
//   final List<String> _currencyOptions = ['MMK', 'USD', 'EUR', 'SGD'];
//   final List<String> _reasonOptions = ['Renewal', 'Adjustment', 'Termination'];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _currentTabIndex = _tabController.index;
//       });
//     });

//     // Load initial data if provided (for editing)
//     final initial = widget.initialLease ?? Lease.empty();
//     _codeController.text = initial.code;
//     _leaseTypeController.text = initial.leaseType;
//     _descriptionController.text = initial.description;
//     _leasorNameController.text = initial.leasorName;
//     _contractDateController.text = initial.contractDate;
//     _phoneNoController.text = initial.phoneNo;
//     _emailController.text = initial.email;
//     _locationController.text = initial.location;
//     _commencementDateController.text = initial.commencementDate;
//     _expiryDateController.text = initial.expiryDate;

//     final fin = initial.financial;
//     _contractAmountController.text = fin.contractAmount.toString();
//     _depositController.text = fin.deposit.toString();
//     _downpaymentController.text = fin.downpayment.toString();
//     _otherCostController.text = fin.otherCost.toString();
//     _dismantlingCostController.text = fin.dismantlingCost.toString();
//     _leaseTermController.text = fin.leaseTerm.toString();
//     _leasePeriodController.text = fin.leasePeriod;
//     _presentValueController.text = fin.presentValue.toString();
//     _discountRateController.text = fin.discountRate.toString();
//     _exchangeRateController.text = fin.exchangeRate.toString();
//     _paymentFrequencyController.text = fin.paymentFrequency.toString();
//     _paymentPeriodController.text = fin.paymentPeriod;
//     _computationController.text = fin.computation;
//     _currencyController.text = fin.currency;
//     _homeCurrencyController.text = fin.homeCurrency;
//     _reasonController.text = fin.reason;
//     _changingDateController.text = fin.changingDate;
//     _changingAmountController.text = fin.changingAmount.toString();
//     _commencementDateController.text = fin.startDate;
//     _expiryDateController.text = fin.endDate;
//   }

//   // ---------- Helper: Show date picker ----------
//   Future<void> _selectDate(TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         controller.text = DateFormat('yyyy-MM-dd').format(picked);
//       });
//     }
//   }

//   // ---------- Validation per tab ----------
//   bool _validateTab1() {
//     return _codeController.text.isNotEmpty &&
//         _leaseTypeController.text.isNotEmpty &&
//         _leasorNameController.text.isNotEmpty &&
//         _contractDateController.text.isNotEmpty &&
//         _commencementDateController.text.isNotEmpty &&
//         _expiryDateController.text.isNotEmpty;
//   }

//   bool _validateTab2() {
//     return _contractAmountController.text.isNotEmpty;
//   }

//   // ---------- Navigation with validation ----------
//   void _navigateToTab(int targetIndex) {
//     bool canNavigate = false;
//     if (_currentTabIndex == 0) {
//       canNavigate = _validateTab1();
//       if (!canNavigate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Please fill all required fields in Lease Info tab'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else if (_currentTabIndex == 1) {
//       canNavigate = _validateTab2();
//       if (!canNavigate) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Please fill all required fields in Financial Details tab',
//             ),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       canNavigate = true;
//     }

//     if (canNavigate) {
//       _tabController.animateTo(targetIndex);
//     }
//   }

//   // ---------- Clear current tab ----------
//   void _clearTab1() {
//     _codeController.clear();
//     _leaseTypeController.clear();
//     _descriptionController.clear();
//     _leasorNameController.clear();
//     _contractDateController.clear();
//     _phoneNoController.clear();
//     _emailController.clear();
//     _locationController.clear();
//     _commencementDateController.clear();
//     _expiryDateController.clear();
//     _statusController.clear();
//   }

//   void _clearTab2() {
//     _contractAmountController.clear();
//     _depositController.clear();
//     _downpaymentController.clear();
//     _otherCostController.clear();
//     _dismantlingCostController.clear();
//     _leaseTermController.clear();
//     _leasePeriodController.clear();
//     _presentValueController.clear();
//     _discountRateController.clear();
//     _exchangeRateController.text = '1.0';
//     _paymentFrequencyController.clear();
//     _paymentPeriodController.clear();
//     _computationController.clear();
//     _currencyController.clear();
//     _homeCurrencyController.clear();
//     _reasonController.clear();
//     _changingDateController.clear();
//     _changingAmountController.clear();
//     _startDateController.clear();
//     _endDateController.clear();
//   }

//   // ---------- Save all data (UPDATED with async and error handling) ----------
//   Future<void> _saveForm() async {
//     if (_validateTab1() && _validateTab2()) {
//       setState(() => _isSaving = true);

//       try {
//         // Build Financial object
//         final financial = Financial(
//           id: widget.initialLease?.financial.id ?? 0,
//           contractAmount:
//               double.tryParse(_contractAmountController.text) ?? 0.0,
//           deposit: double.tryParse(_depositController.text) ?? 0.0,
//           downpayment: double.tryParse(_downpaymentController.text) ?? 0.0,
//           otherCost: double.tryParse(_otherCostController.text) ?? 0.0,
//           dismantlingCost:
//               double.tryParse(_dismantlingCostController.text) ?? 0.0,
//           leaseTerm: double.tryParse(_leaseTermController.text) ?? 0.0,
//           leasePeriod: _leasePeriodController.text,
//           presentValue: double.tryParse(_presentValueController.text) ?? 0.0,
//           discountRate: double.tryParse(_discountRateController.text) ?? 0.0,
//           exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1.0,
//           paymentFrequency:
//               double.tryParse(_paymentFrequencyController.text) ?? 0.0,
//           paymentPeriod: _paymentPeriodController.text,
//           computation: _computationController.text,
//           currency: _currencyController.text.isNotEmpty
//               ? _currencyController.text
//               : 'MMK',
//           homeCurrency: _homeCurrencyController.text.isNotEmpty
//               ? _homeCurrencyController.text
//               : 'MMK',
//           reason: _reasonController.text,
//           changingDate: _changingDateController.text,
//           changingAmount:
//               double.tryParse(_changingAmountController.text) ?? 0.0,
//           startDate: _startDateController.text,
//           endDate: _endDateController.text,
//           paymentTiming: 'Advance',
//           discountRateType: 'IBR',
//           escalationType: 'Fixed',
//           leaseId: 0,
//           amortizationSchedule: [],
//         );

//         // Build Lease object
//         final lease = Lease(
//           id: widget.initialLease?.id ?? 0,
//           code: _codeController.text,
//           leaseType: _leaseTypeController.text,
//           description: _descriptionController.text,
//           leasorName: _leasorNameController.text,
//           contractDate: _contractDateController.text,
//           phoneNo: _phoneNoController.text,
//           email: _emailController.text,
//           location: _locationController.text,
//           commencementDate: _commencementDateController.text,
//           expiryDate: _expiryDateController.text,
//           status: 'Active', // automatically set
//           financial: financial,
//         );

//         // Send only the lease (financial is nested inside)
//         await ApiService().postLease(lease);
//         await ApiService().postLeaseFinancial(financial);

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Lease saved successfully!')),
//           );
//           // Optionally clear form or navigate back
//           // Navigator.pop(context, true);
//         }
//       } catch (e) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Error saving lease: $e'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       } finally {
//         if (mounted) {
//           setState(() => _isSaving = false);
//         }
//       }
//     } else {
//       String errorMessage = 'Please fill all required fields in:\n';
//       if (!_validateTab1()) errorMessage += '• Lease Info tab\n';
//       if (!_validateTab2()) errorMessage += '• Financial Details tab\n';
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(errorMessage),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     }
//   }

//   // ---------- UI Helpers ----------
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Enter ${label.toLowerCase()}',
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//             ),
//             validator: required
//                 ? (value) => value == null || value.isEmpty ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdownField(
//     String label,
//     TextEditingController controller,
//     List<String> options, {
//     bool required = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           DropdownButtonFormField<String>(
//             value: controller.text.isNotEmpty ? controller.text : null,
//             decoration: const InputDecoration(
//               border: OutlineInputBorder(),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//             ),
//             icon: const Icon(Icons.arrow_drop_down, size: 20),
//             items: options.map((option) {
//               return DropdownMenuItem(
//                 value: option,
//                 child: Text(option, style: const TextStyle(fontSize: 14)),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 controller.text = value ?? '';
//               });
//             },
//             validator: required
//                 ? (value) => value == null ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDateField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildLabel(required ? '$label *' : label),
//           TextFormField(
//             controller: controller,
//             readOnly: true,
//             style: const TextStyle(fontSize: 14),
//             decoration: InputDecoration(
//               hintText: 'Select date',
//               border: const OutlineInputBorder(),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 12,
//               ),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.calendar_today, size: 16),
//                 onPressed: () => _selectDate(controller),
//               ),
//             ),
//             validator: required
//                 ? (value) => value == null || value.isEmpty ? 'Required' : null
//                 : null,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNumberField(
//     String label,
//     TextEditingController controller, {
//     bool required = false,
//   }) {
//     return _buildTextField(
//       label,
//       controller,
//       required: required,
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//     );
//   }

//   // ---------- Tab Contents ----------
//   Widget _buildLeaseInfoTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField('Code', _codeController, required: true),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Lease Type',
//                   _leaseTypeController,
//                   _leaseTypeOptions,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//           _buildTextField('Description', _descriptionController),
//           _buildTextField('Leasor Name', _leasorNameController, required: true),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField(
//                   'Email',
//                   _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildTextField(
//                   'Phone No',
//                   _phoneNoController,
//                   keyboardType: TextInputType.phone,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildTextField('Location', _locationController)),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateField(
//                   'Contract Date',
//                   _contractDateController,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   'Commencement Date',
//                   _commencementDateController,
//                   required: true,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildDateField(
//                   'Expiry Date',
//                   _expiryDateController,
//                   required: true,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFinancialDetailsTab() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           // Row 1: Contract Amount, Currency, Dismantling Cost, Other Cost
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: _buildNumberField(
//                   'Contract Amount',
//                   _contractAmountController,
//                   required: true,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 1,
//                 child: _buildDropdownField(
//                   'Currency',
//                   _currencyController,
//                   _currencyOptions,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 3,
//                 child: _buildNumberField(
//                   'Dismantling Cost',
//                   _dismantlingCostController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 flex: 3,
//                 child: _buildNumberField('Other Cost', _otherCostController),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 2: Deposit, Downpayment, Total Amount
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(child: _buildNumberField('Deposit', _depositController)),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Downpayment', _downpaymentController),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Total Amount',
//                   _totalamountController,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 3: Home Currency, Exchange Rate, Discount Rate, Computation
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildTextField(
//                   'Home Currency',
//                   _homeCurrencyController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Exchange Rate',
//                   _exchangeRateController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Discount Rate',
//                   _discountRateController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Computation',
//                   _computationController,
//                   _computationOptions,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 4: Payment Frequency, Payment Period, Lease Term, Lease Period
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildNumberField(
//                   'Payment Frequency',
//                   _paymentFrequencyController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Payment Period',
//                   _paymentPeriodController,
//                   _paymentPeriodOptions,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField('Lease Term', _leaseTermController),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildDropdownField(
//                   'Lease Period',
//                   _leasePeriodController,
//                   _leasePeriodOptions,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Row 5: Changing Date, Changing Amount
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: _buildDateField(
//                   'Changing Date',
//                   _changingDateController,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: _buildNumberField(
//                   'Changing Amount',
//                   _changingAmountController,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lease Registration'),
//         centerTitle: true,
//         backgroundColor: Colors.blue[800],
//         foregroundColor: Colors.white,
//         elevation: 2,
//       ),
//       body: Container(
//         color: Colors.grey[100],
//         child: Center(
//           child: Container(
//             width: 1000,
//             height: 650,
//             margin: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   // Tabs
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.blue[50],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(10),
//                         topRight: Radius.circular(10),
//                       ),
//                       border: Border(
//                         bottom: BorderSide(color: Colors.blue.shade200),
//                       ),
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       tabs: const [
//                         Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.info, size: 16),
//                               SizedBox(width: 4),
//                               Text(
//                                 'Lease Info',
//                                 style: TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Tab(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(Icons.attach_money, size: 16),
//                               SizedBox(width: 4),
//                               Text('Financial', style: TextStyle(fontSize: 12)),
//                             ],
//                           ),
//                         ),
//                       ],
//                       indicatorColor: Colors.blue[800],
//                       labelColor: Colors.blue[800],
//                       unselectedLabelColor: Colors.grey[600],
//                     ),
//                   ),
//                   // Tab content
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       child: TabBarView(
//                         controller: _tabController,
//                         children: [
//                           _buildLeaseInfoTab(),
//                           _buildFinancialDetailsTab(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   // Bottom buttons
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       border: Border(
//                         top: BorderSide(color: Colors.grey.shade300),
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(10),
//                         bottomRight: Radius.circular(10),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Clear current tab
//                         OutlinedButton(
//                           onPressed: _currentTabIndex == 0
//                               ? _clearTab1
//                               : _clearTab2,
//                           style: OutlinedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20,
//                               vertical: 10,
//                             ),
//                             side: const BorderSide(
//                               color: Colors.orange,
//                               width: 1,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                           ),
//                           child: Text(
//                             'Clear Tab ${_currentTabIndex + 1}',
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ),
//                         // Navigation
//                         Row(
//                           children: [
//                             if (_currentTabIndex > 0)
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _navigateToTab(_currentTabIndex - 1),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey[600],
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Icon(
//                                       Icons.arrow_back,
//                                       size: 14,
//                                       color: Colors.white,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       'Previous',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             if (_currentTabIndex > 0 && _currentTabIndex < 1)
//                               const SizedBox(width: 8),
//                             if (_currentTabIndex < 1)
//                               ElevatedButton(
//                                 onPressed: () =>
//                                     _navigateToTab(_currentTabIndex + 1),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue[800],
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 10,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                                 child: const Row(
//                                   children: [
//                                     Text(
//                                       'Next',
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Icon(
//                                       Icons.arrow_forward,
//                                       size: 14,
//                                       color: Colors.white,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                         // Save button (only on last tab = Financial) with loading indicator
//                         if (_currentTabIndex == 1)
//                           ElevatedButton(
//                             onPressed: _isSaving ? null : _saveForm,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green[700],
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                             child: _isSaving
//                                 ? const SizedBox(
//                                     width: 16,
//                                     height: 16,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       valueColor: AlwaysStoppedAnimation<Color>(
//                                         Colors.white,
//                                       ),
//                                     ),
//                                   )
//                                 : const Row(
//                                     children: [
//                                       Icon(
//                                         Icons.save,
//                                         size: 14,
//                                         color: Colors.white,
//                                       ),
//                                       SizedBox(width: 4),
//                                       Text(
//                                         'Save',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           )
//                         else
//                           const SizedBox(width: 80), // placeholder alignment
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     // Lease controllers
//     _codeController.dispose();
//     _leaseTypeController.dispose();
//     _descriptionController.dispose();
//     _leasorNameController.dispose();
//     _contractDateController.dispose();
//     _phoneNoController.dispose();
//     _emailController.dispose();
//     _locationController.dispose();
//     _commencementDateController.dispose();
//     _expiryDateController.dispose();
//     _statusController.dispose();
//     // Financial controllers
//     _contractAmountController.dispose();
//     _depositController.dispose();
//     _downpaymentController.dispose();
//     _otherCostController.dispose();
//     _dismantlingCostController.dispose();
//     _leaseTermController.dispose();
//     _leasePeriodController.dispose();
//     _presentValueController.dispose();
//     _discountRateController.dispose();
//     _exchangeRateController.dispose();
//     _paymentFrequencyController.dispose();
//     _paymentPeriodController.dispose();
//     _computationController.dispose();
//     _currencyController.dispose();
//     _homeCurrencyController.dispose();
//     _reasonController.dispose();
//     _changingDateController.dispose();
//     _changingAmountController.dispose();
//     _startDateController.dispose();
//     _endDateController.dispose();
//     super.dispose();
//   }
// }

// lease_entry_form.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';

class LeaseEntryForm extends StatefulWidget {
  final Lease? initialLease;

  const LeaseEntryForm({Key? key, this.initialLease}) : super(key: key);

  @override
  State<LeaseEntryForm> createState() => _LeaseEntryFormState();
}

class _LeaseEntryFormState extends State<LeaseEntryForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isSaving = false;

  // Controllers for Lease (Tab 1)
  final _codeController = TextEditingController();
  final _leaseTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _leasorNameController = TextEditingController();
  final _contractDateController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _commencementDateController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _statusController = TextEditingController();

  // Controllers for Financial (Tab 2)
  final _contractAmountController = TextEditingController();
  final _depositController = TextEditingController();
  final _downpaymentController = TextEditingController();
  final _otherCostController = TextEditingController();
  final _dismantlingCostController = TextEditingController();
  final _leaseTermController = TextEditingController();
  final _leasePeriodController = TextEditingController();
  final _presentValueController = TextEditingController();
  final _discountRateController = TextEditingController();
  final _exchangeRateController = TextEditingController(text: '1.0');
  final _paymentFrequencyController = TextEditingController();
  final _paymentPeriodController = TextEditingController();
  final _computationController = TextEditingController();
  final _currencyController = TextEditingController();
  final _homeCurrencyController = TextEditingController(text: 'MMK');
  final _reasonController = TextEditingController();
  final _changingDateController = TextEditingController();
  final _changingAmountController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _totalamountController = TextEditingController();

  // Dropdown options
  final _leaseTypeOptions = [
    'Building',
    'Land',
    'Office Equipment',
    'Vehicle',
    'Other',
  ];
  final _statusOptions = ['Active', 'Completed', 'Amendment', 'Cancelled'];
  final _leasePeriodOptions = ['Month', 'Year', 'Quaterly'];
  final _paymentPeriodOptions = ['Monthly', 'Quarterly', 'Annually'];
  final _computationOptions = ['Monthly', 'Yearly'];
  final _currencyOptions = ['MMK', 'USD', 'EUR', 'SGD'];
  final _reasonOptions = ['Renewal', 'Adjustment', 'Termination'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    _populateFromInitial();
  }

  void _populateFromInitial() {
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
  }

  // ✅ Helper to format date to YYYY-MM-DD
  String _formatDateString(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      print('Invalid date: $dateStr');
      return '';
    }
  }

  // Validation
  bool _validateTab1() {
    return _codeController.text.isNotEmpty &&
        _leaseTypeController.text.isNotEmpty &&
        _leasorNameController.text.isNotEmpty &&
        _contractDateController.text.isNotEmpty &&
        _commencementDateController.text.isNotEmpty &&
        _expiryDateController.text.isNotEmpty;
  }

  bool _validateTab2() {
    // If you added financial start/end date fields, include them:
    // return _contractAmountController.text.isNotEmpty &&
    //        _startDateController.text.isNotEmpty &&
    //        _endDateController.text.isNotEmpty;
    return _contractAmountController.text.isNotEmpty;
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

  void _navigateToTab(int targetIndex) {
    bool canNavigate = false;
    if (_currentTabIndex == 0) {
      canNavigate = _validateTab1();
      if (!canNavigate) {
        _showSnack('Please fill all required fields in Lease Info tab');
      }
    } else if (_currentTabIndex == 1) {
      canNavigate = _validateTab2();
      if (!canNavigate) {
        _showSnack('Please fill all required fields in Financial Details tab');
      }
    } else {
      canNavigate = true;
    }
    if (canNavigate) {
      _tabController.animateTo(targetIndex);
    }
  }

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

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _saveForm() async {
    if (_validateTab1() && _validateTab2()) {
      setState(() => _isSaving = true);

      try {
        // ----- 1. Prepare a temporary Financial (leaseId = 0) -----
        final tempFinancial = Financial(
          id: 0,
          contractAmount: double.tryParse(_contractAmountController.text) ?? 0,
          deposit: double.tryParse(_depositController.text) ?? 0,
          downpayment: double.tryParse(_downpaymentController.text) ?? 0,
          otherCost: double.tryParse(_otherCostController.text) ?? 0,
          dismantlingCost:
              double.tryParse(_dismantlingCostController.text) ?? 0,
          leaseTerm: double.tryParse(_leaseTermController.text) ?? 0,
          leasePeriod: _leasePeriodController.text,
          presentValue: double.tryParse(_presentValueController.text) ?? 0,
          discountRate: double.tryParse(_discountRateController.text) ?? 0,
          exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1,
          paymentFrequency:
              double.tryParse(_paymentFrequencyController.text) ?? 0,
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
          changingAmount: double.tryParse(_changingAmountController.text) ?? 0,

          startDate: _formatDateString(
            _startDateController.text.isNotEmpty
                ? _startDateController.text
                : _commencementDateController.text,
          ),
          endDate: _formatDateString(
            _endDateController.text.isNotEmpty
                ? _endDateController.text
                : _expiryDateController.text,
          ),
          paymentTiming: 'Advance',
          discountRateType: 'IBR',
          escalationType: 'Fixed',
          leaseId: 0, // temporary
          amortizationSchedule: [],
        );

        // ----- 2. Build the Lease with the temporary financial -----
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
          status: 'Active',
          financial: tempFinancial,
        );

        // ----- 3. Create the lease and get its ID -----
        final newLeaseId = await ApiService().postLease(lease);

        // ----- 4. Create the final Financial with the real lease ID -----
        final finalFinancial = Financial(
          id: 0,
          contractAmount: double.tryParse(_contractAmountController.text) ?? 0,
          deposit: double.tryParse(_depositController.text) ?? 0,
          downpayment: double.tryParse(_downpaymentController.text) ?? 0,
          otherCost: double.tryParse(_otherCostController.text) ?? 0,
          dismantlingCost:
              double.tryParse(_dismantlingCostController.text) ?? 0,
          leaseTerm: double.tryParse(_leaseTermController.text) ?? 0,
          leasePeriod: _leasePeriodController.text,
          presentValue: double.tryParse(_presentValueController.text) ?? 0,
          discountRate: double.tryParse(_discountRateController.text) ?? 0,
          exchangeRate: double.tryParse(_exchangeRateController.text) ?? 1,
          paymentFrequency:
              double.tryParse(_paymentFrequencyController.text) ?? 0,
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
          changingAmount: double.tryParse(_changingAmountController.text) ?? 0,
          startDate: _formatDateString(
            _startDateController.text.isNotEmpty
                ? _startDateController.text
                : _commencementDateController.text,
          ),
          endDate: _formatDateString(
            _endDateController.text.isNotEmpty
                ? _endDateController.text
                : _expiryDateController.text,
          ),
          paymentTiming: 'Advance',
          discountRateType: 'IBR',
          escalationType: 'Fixed',
          leaseId: newLeaseId,
          amortizationSchedule: [],
        );

        // ----- 5. Post the financial data -----
        await ApiService().postLeaseFinancial(finalFinancial);

        if (mounted) {
          _showSnack('Lease saved successfully!', isError: false);
          // Optionally clear or navigate back
          // Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          _showSnack('Error saving lease: $e');
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    } else {
      String errorMsg = 'Please fill all required fields in:\n';
      if (!_validateTab1()) errorMsg += '• Lease Info tab\n';
      if (!_validateTab2()) errorMsg += '• Financial Details tab\n';
      _showSnack(errorMsg);
    }
  }

  // ---------- UI Helpers (unchanged) ----------
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField('Code', _codeController, required: true),
              ),
              const SizedBox(width: 12),
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
          _buildTextField('Description', _descriptionController),
          _buildTextField('Leasor Name', _leasorNameController, required: true),
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
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  'Phone No',
                  _phoneNoController,
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildTextField('Location', _locationController)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  'Contract Date',
                  _contractDateController,
                  required: true,
                ),
              ),
            ],
          ),
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
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField(
                  'Expiry Date',
                  _expiryDateController,
                  required: true,
                ),
              ),
            ],
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
          // Row 1: Contract Amount, Currency, Dismantling Cost, Other Cost
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: _buildNumberField(
                  'Contract Amount',
                  _contractAmountController,
                  required: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _buildDropdownField(
                  'Currency',
                  _currencyController,
                  _currencyOptions,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _buildNumberField(
                  'Dismantling Cost',
                  _dismantlingCostController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: _buildNumberField('Other Cost', _otherCostController),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: Deposit, Downpayment, Total Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildNumberField('Deposit', _depositController)),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Downpayment', _downpaymentController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Total Amount',
                  _totalamountController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 3: Home Currency, Exchange Rate, Discount Rate, Computation
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildTextField(
                  'Home Currency',
                  _homeCurrencyController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Exchange Rate',
                  _exchangeRateController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Discount Rate',
                  _discountRateController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Computation',
                  _computationController,
                  _computationOptions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 4: Payment Frequency, Payment Period, Lease Term, Lease Period
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildNumberField(
                  'Payment Frequency',
                  _paymentFrequencyController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Payment Period',
                  _paymentPeriodController,
                  _paymentPeriodOptions,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField('Lease Term', _leaseTermController),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdownField(
                  'Lease Period',
                  _leasePeriodController,
                  _leasePeriodOptions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 5: Changing Date, Changing Amount
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDateField(
                  'Changing Date',
                  _changingDateController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildNumberField(
                  'Changing Amount',
                  _changingAmountController,
                ),
              ),
            ],
          ),
        ],
      ),
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
                              : _clearTab2,
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
                            if (_currentTabIndex > 0 && _currentTabIndex < 1)
                              const SizedBox(width: 8),
                            if (_currentTabIndex < 1)
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
                        // Save button (only on last tab = Financial)
                        if (_currentTabIndex == 1)
                          ElevatedButton(
                            onPressed: _isSaving ? null : _saveForm,
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
                            child: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    children: [
                                      Icon(
                                        Icons.save,
                                        size: 14,
                                        color: Colors.white,
                                      ),
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
                          const SizedBox(width: 80), // placeholder
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
