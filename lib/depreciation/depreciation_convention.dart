// import 'package:flutter/material.dart';

// class DepreciationConvention {
//   final String value;
//   final String displayName;
//   final Map<String, bool> flags;
//   final String notes;
//   final bool isActive; // Added for disable functionality

//   const DepreciationConvention({
//     required this.value,
//     required this.displayName,
//     required this.flags,
//     required this.notes,
//     this.isActive = true, // Default to active
//   });

//   // Copy with method for immutability
//   DepreciationConvention copyWith({
//     String? value,
//     String? displayName,
//     Map<String, bool>? flags,
//     String? notes,
//     bool? isActive,
//   }) {
//     return DepreciationConvention(
//       value: value ?? this.value,
//       displayName: displayName ?? this.displayName,
//       flags: flags ?? this.flags,
//       notes: notes ?? this.notes,
//       isActive: isActive ?? this.isActive,
//     );
//   }

//   // Factory method to create from JSON (for API responses)
//   factory DepreciationConvention.fromJson(Map<String, dynamic> json) {
//     return DepreciationConvention(
//       value: json['value'] as String,
//       displayName: json['displayName'] as String,
//       flags: Map<String, bool>.from(json['flags'] as Map),
//       notes: json['notes'] as String,
//       isActive: json['isActive'] as bool? ?? true,
//     );
//   }

//   // Convert to JSON (for API requests)
//   Map<String, dynamic> toJson() {
//     return {
//       'value': value,
//       'displayName': displayName,
//       'flags': flags,
//       'notes': notes,
//       'isActive': isActive,
//     };
//   }
// }

// // Reusable Depreciation Convention Selector Widget
// class DepreciationConventionSelector extends StatefulWidget {
//   final DepreciationConvention? initialConvention;
//   final List<DepreciationConvention> conventions;
//   final Function(DepreciationConvention?) onConventionChanged;
//   final bool showButtons;
//   final bool showNotes;
//   final bool showFlags;
//   final String? labelText;
//   final String? hintText;
//   final bool readOnly;
//   final EdgeInsets padding;
//   final bool showActiveOnly; // Show only active conventions

//   const DepreciationConventionSelector({
//     super.key,
//     this.initialConvention,
//     required this.conventions,
//     required this.onConventionChanged,
//     this.showButtons = false,
//     this.showNotes = true,
//     this.showFlags = true,
//     this.labelText = 'Convention List *',
//     this.hintText = 'Select a convention',
//     this.readOnly = false,
//     this.padding = const EdgeInsets.all(16),
//     this.showActiveOnly = true,
//   });

//   @override
//   State<DepreciationConventionSelector> createState() =>
//       _DepreciationConventionSelectorState();
// }

// class _DepreciationConventionSelectorState
//     extends State<DepreciationConventionSelector> {
//   DepreciationConvention? _selectedConvention;

//   @override
//   void initState() {
//     super.initState();
//     _selectedConvention = widget.initialConvention;
//   }

//   List<DepreciationConvention> get _filteredConventions {
//     if (widget.showActiveOnly) {
//       return widget.conventions.where((c) => c.isActive).toList();
//     }
//     return widget.conventions;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: widget.padding,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Convention Dropdown
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 widget.labelText!,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade400),
//                   borderRadius: BorderRadius.circular(4.0),
//                 ),
//                 child: DropdownButtonFormField<DepreciationConvention>(
//                   value: _selectedConvention,
//                   isExpanded: true,
//                   hint: Text(widget.hintText!),
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                   ),
//                   items: _filteredConventions.map((convention) {
//                     return DropdownMenuItem(
//                       value: convention,
//                       child: Text(
//                         convention.displayName,
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         style: TextStyle(
//                           color: convention.isActive
//                               ? Colors.black
//                               : Colors.grey,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: widget.readOnly
//                       ? null
//                       : (newValue) {
//                           setState(() {
//                             _selectedConvention = newValue;
//                           });
//                           widget.onConventionChanged(newValue);
//                         },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Please select a convention';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//             ],
//           ),

//           if (_selectedConvention != null && widget.showFlags) ...[
//             const SizedBox(height: 20),

//             // Behavior Flags Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Behavior Flags:',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildFlagRow(
//                         'Apply Pro-rata on Acquisition:',
//                         _selectedConvention!.flags['proRataAcq'] ?? false,
//                       ),
//                       const Divider(height: 1),
//                       _buildFlagRow(
//                         'Apply Pro-rata on Disposal:',
//                         _selectedConvention!.flags['proRataDisp'] ?? false,
//                       ),
//                       const Divider(height: 1),
//                       _buildFlagRow(
//                         'Full Depreciation in Acquisition Yr:',
//                         _selectedConvention!.flags['fullDepAcq'] ?? false,
//                       ),
//                       const Divider(height: 1),
//                       _buildFlagRow(
//                         'No Depreciation in Disposal Yr:',
//                         _selectedConvention!.flags['noDepDisp'] ?? false,
//                       ),
//                       const Divider(height: 1),
//                       _buildFlagRow(
//                         'Start From Next Financial Year:',
//                         _selectedConvention!.flags['startNextFinYear'] ?? false,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],

//           if (_selectedConvention != null && widget.showNotes) ...[
//             const SizedBox(height: 20),

//             // Notes Section
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Notes:',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade50,
//                     border: Border.all(color: Colors.grey.shade300),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: Text(
//                     _selectedConvention!.notes,
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//           SizedBox(height: 20),

//           if (_selectedConvention == null)
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.blue[50],
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.blue.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info_outline, color: Colors.blue[800], size: 18),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'Please select a convention from the dropdown to view its behavior flags and notes.',
//                       style: TextStyle(fontSize: 12, color: Colors.blue[800]),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFlagRow(String label, bool value) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       color: Colors.white,
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Radio<bool>(
//                         value: true,
//                         groupValue: value,
//                         onChanged: null,
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         fillColor: MaterialStateProperty.all(Colors.blue[800]),
//                       ),
//                       const Text('Yes', style: TextStyle(fontSize: 13)),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Radio<bool>(
//                         value: false,
//                         groupValue: value,
//                         onChanged: null,
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         fillColor: MaterialStateProperty.all(Colors.blue[800]),
//                       ),
//                       const Text('No', style: TextStyle(fontSize: 13)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Main Form that uses the reusable selector
// class DepreciationConventionForm extends StatefulWidget {
//   const DepreciationConventionForm({super.key});

//   @override
//   State<DepreciationConventionForm> createState() =>
//       _DepreciationConventionFormState();
// }

// class _DepreciationConventionFormState
//     extends State<DepreciationConventionForm> {
//   final _formKey = GlobalKey<FormState>();

//   // List of conventions
//   final List<DepreciationConvention> conventions = const [
//     DepreciationConvention(
//       value: 'EXACT_DATE_IFRS',
//       displayName: 'EXACT_DATE_IFRS - Exact date, daily pro-rata',
//       flags: {
//         'proRataAcq': true,
//         'proRataDisp': true,
//         'fullDepAcq': false,
//         'noDepDisp': false,
//         'startNextFinYear': false,
//       },
//       notes:
//           'Daily pro‑rata depreciation on both acquisition and disposal dates. Full year is prorated by actual number of days used.',
//       isActive: true,
//     ),
//     DepreciationConvention(
//       value: 'MONTHLY_PRORATA',
//       displayName: 'MONTHLY_PRORATA - Monthly pro-rata',
//       flags: {
//         'proRataAcq': true,
//         'proRataDisp': true,
//         'fullDepAcq': false,
//         'noDepDisp': false,
//         'startNextFinYear': false,
//       },
//       notes:
//           'Monthly pro‑rata depreciation; acquisition and disposal months are prorated based on number of months used.',
//       isActive: true,
//     ),
//     DepreciationConvention(
//       value: 'FULL_YEAR_NO_ACQ',
//       displayName: 'FULL_YEAR_NO_ACQ - No depreciation in acquisition year',
//       flags: {
//         'proRataAcq': false,
//         'proRataDisp': false,
//         'fullDepAcq': false,
//         'noDepDisp': false,
//         'startNextFinYear': true,
//       },
//       notes:
//           'No depreciation in acquisition year; depreciation starts from the next financial year with full-year depreciation.',
//       isActive: true,
//     ),
//     DepreciationConvention(
//       value: 'FULL_YEAR_NO_DISP',
//       displayName:
//           'FULL_YEAR_NO_DISP - Full depreciation in acquisition year; none in disposal year',
//       flags: {
//         'proRataAcq': false,
//         'proRataDisp': false,
//         'fullDepAcq': true,
//         'noDepDisp': true,
//         'startNextFinYear': false,
//       },
//       notes:
//           'Full depreciation in acquisition year; zero depreciation in disposal year.',
//       isActive: true,
//     ),
//     DepreciationConvention(
//       value: 'HALF_YEAR',
//       displayName: 'HALF_YEAR - Half-year convention',
//       flags: {
//         'proRataAcq': false,
//         'proRataDisp': false,
//         'fullDepAcq': false,
//         'noDepDisp': false,
//         'startNextFinYear': false,
//       },
//       notes:
//           'Half-year depreciation is applied in both acquisition and disposal years; remaining years receive full-year depreciation.',
//       isActive: true,
//     ),
//   ];

//   // Selected convention
//   DepreciationConvention? _selectedConvention;
//   bool _isLoading = false;

//   // Example of a disabled convention for demonstration
//   final List<DepreciationConvention> _mixedConventions = const [
//     DepreciationConvention(
//       value: 'EXACT_DATE_IFRS',
//       displayName: 'EXACT_DATE_IFRS - Exact date, daily pro-rata',
//       flags: {
//         'proRataAcq': true,
//         'proRataDisp': true,
//         'fullDepAcq': false,
//         'noDepDisp': false,
//         'startNextFinYear': false,
//       },
//       notes:
//           'Daily pro‑rata depreciation on both acquisition and disposal dates.',
//       isActive: true,
//     ),
//     DepreciationConvention(
//       value: 'OLD_CONVENTION',
//       displayName: 'OLD_CONVENTION - Legacy (Disabled)',
//       flags: {
//         'proRataAcq': false,
//         'proRataDisp': false,
//         'fullDepAcq': true,
//         'noDepDisp': false,
//         'startNextFinYear': true,
//       },
//       notes: 'This convention is no longer recommended.',
//       isActive: false,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('DEPRECIATION CONVENTIONS (MASTER)'),
//       //   centerTitle: true,
//       //   backgroundColor: Colors.blue[800],
//       //   foregroundColor: Colors.white,
//       // ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 800),
//             padding: const EdgeInsets.all(24.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Center(
//                     child: Text(
//                       'Depreciation Convention Master',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue[800],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 30),

//                   // Reusable Convention Selector
//                   DepreciationConventionSelector(
//                     initialConvention: _selectedConvention,
//                     conventions: conventions,
//                     onConventionChanged: (convention) {
//                       setState(() {
//                         _selectedConvention = convention;
//                       });
//                     },
//                     showButtons: false, // No buttons in selector
//                   ),

//                   const SizedBox(height: 30),

//                   // Action Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: _isLoading ? null : _saveForm,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[800],
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 12,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4.0),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                                 width: 20,
//                                 height: 20,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                 ),
//                               )
//                             : const Text(
//                                 'Save',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                       const SizedBox(width: 20),
//                       OutlinedButton(
//                         onPressed: _isLoading ? null : _clearForm,
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 40,
//                             vertical: 12,
//                           ),
//                           side: BorderSide(color: Colors.blue[800]!),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(4.0),
//                           ),
//                         ),
//                         child: Text(
//                           'Clear',
//                           style: TextStyle(
//                             color: Colors.blue[800],
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),

//                   // Management Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TextButton.icon(
//                         onPressed: () {
//                           _showAddConventionDialog();
//                         },
//                         icon: Icon(
//                           Icons.add,
//                           color: Colors.blue[800],
//                           size: 20,
//                         ),
//                         label: Text(
//                           'Add New Convention',
//                           style: TextStyle(
//                             color: Colors.blue[800],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 24,
//                         width: 1,
//                         color: Colors.grey.shade300,
//                         margin: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       TextButton.icon(
//                         onPressed: _selectedConvention != null
//                             ? () {
//                                 _showEditConventionDialog();
//                               }
//                             : null,
//                         icon: Icon(
//                           Icons.edit,
//                           color: _selectedConvention != null
//                               ? Colors.blue[800]
//                               : Colors.grey,
//                           size: 20,
//                         ),
//                         label: Text(
//                           'Edit',
//                           style: TextStyle(
//                             color: _selectedConvention != null
//                                 ? Colors.blue[800]
//                                 : Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 24,
//                         width: 1,
//                         color: Colors.grey.shade300,
//                         margin: const EdgeInsets.symmetric(horizontal: 16),
//                       ),
//                       TextButton.icon(
//                         onPressed: _selectedConvention != null
//                             ? () {
//                                 _showDisableConfirmation();
//                               }
//                             : null,
//                         icon: Icon(
//                           Icons.block,
//                           color: _selectedConvention != null
//                               ? Colors.red
//                               : Colors.grey,
//                           size: 20,
//                         ),
//                         label: Text(
//                           'Disable',
//                           style: TextStyle(
//                             color: _selectedConvention != null
//                                 ? Colors.red
//                                 : Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 10),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Example: Using the selector in a different context (read-only mode)
//   Widget _buildReadOnlyExample() {
//     return DepreciationConventionSelector(
//       initialConvention: conventions.first,
//       conventions: conventions,
//       onConventionChanged: (convention) {
//         // This won't be called because readOnly is true
//       },
//       readOnly: true,
//       showButtons: false,
//       labelText: 'Selected Convention (Read Only)',
//     );
//   }

//   // Example: Using the selector with mixed active/inactive conventions
//   Widget _buildMixedConventionsExample() {
//     return Column(
//       children: [
//         // Shows only active conventions
//         DepreciationConventionSelector(
//           conventions: _mixedConventions,
//           onConventionChanged: (convention) {
//             print('Selected: ${convention?.displayName}');
//           },
//           showActiveOnly: true,
//           labelText: 'Active Conventions Only',
//         ),
//         const SizedBox(height: 20),
//         // Shows all conventions (including inactive)
//         DepreciationConventionSelector(
//           conventions: _mixedConventions,
//           onConventionChanged: (convention) {
//             print('Selected: ${convention?.displayName}');
//           },
//           showActiveOnly: false,
//           labelText: 'All Conventions (Inactive shown in grey)',
//         ),
//       ],
//     );
//   }

//   void _showAddConventionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add New Convention'),
//         content: const Text('Add new convention functionality here'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Add convention - To be implemented'),
//                 ),
//               );
//             },
//             child: const Text('Add'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showEditConventionDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Convention'),
//         content: Text('Edit: ${_selectedConvention?.displayName}'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Edit convention - To be implemented'),
//                 ),
//               );
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDisableConfirmation() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Disable Convention'),
//         content: Text(
//           'Are you sure you want to disable "${_selectedConvention?.displayName}"?',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 // In a real app, you would update the convention in your data source
//                 final index = conventions.indexOf(_selectedConvention!);
//                 if (index != -1) {
//                   // Create a new disabled convention
//                   final disabledConvention = _selectedConvention!.copyWith(
//                     isActive: false,
//                   );
//                   // You would need to update your list here
//                 }
//               });
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(
//                     '${_selectedConvention?.displayName} has been disabled',
//                   ),
//                   backgroundColor: Colors.orange,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text('Disable'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearForm() {
//     setState(() {
//       _selectedConvention = null;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Form cleared'),
//         backgroundColor: Colors.blue[800],
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   Future<void> _saveForm() async {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedConvention == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Please select a convention'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         return;
//       }

//       setState(() {
//         _isLoading = true;
//       });

//       try {
//         // Simulate API call
//         await Future.delayed(const Duration(seconds: 1));

//         final savedData = _selectedConvention!.toJson();
//         print('✅ Saved data: $savedData');

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Saved: ${_selectedConvention!.displayName}'),
//             backgroundColor: Colors.green,
//             duration: const Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error saving: ${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } finally {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
// }

import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DepreciationConvention {
  final String value;
  final String displayName;
  final Map<String, bool> flags;
  final String notes;
  final bool isActive;

  const DepreciationConvention({
    required this.value,
    required this.displayName,
    required this.flags,
    required this.notes,
    this.isActive = true,
  });

  DepreciationConvention copyWith({
    String? value,
    String? displayName,
    Map<String, bool>? flags,
    String? notes,
    bool? isActive,
  }) {
    return DepreciationConvention(
      value: value ?? this.value,
      displayName: displayName ?? this.displayName,
      flags: flags ?? this.flags,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  factory DepreciationConvention.fromJson(Map<String, dynamic> json) {
    return DepreciationConvention(
      value: json['value'] as String,
      displayName: json['displayName'] as String,
      flags: Map<String, bool>.from(json['flags'] as Map),
      notes: json['notes'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'displayName': displayName,
      'flags': flags,
      'notes': notes,
      'isActive': isActive,
    };
  }

  // Convert to Convention model for API
  Convention toConvention() {
    return Convention(
      id: 0, // ID will be assigned by the backend
      conventionName: displayName,
      applyProrataAcquisition: flags['proRataAcq'] ?? false,
      applyProrataDisposal: flags['proRataDisp'] ?? false,
      fullDepreInAcquisitionYear: flags['fullDepAcq'] ?? false,
      noDepreInDisposalYear: flags['noDepDisp'] ?? false,
      startFromNextFinancialYear: flags['startNextFinYear'] ?? false,
      note: notes,
    );
  }
}

// Reusable Depreciation Convention Selector Widget
class DepreciationConventionSelector extends StatefulWidget {
  final DepreciationConvention? initialConvention;
  final List<DepreciationConvention> conventions;
  final Function(DepreciationConvention?) onConventionChanged;
  final bool showButtons;
  final bool showNotes;
  final bool showFlags;
  final String? labelText;
  final String? hintText;
  final bool readOnly;
  final EdgeInsets padding;
  final bool showActiveOnly;

  const DepreciationConventionSelector({
    super.key,
    this.initialConvention,
    required this.conventions,
    required this.onConventionChanged,
    this.showButtons = false,
    this.showNotes = true,
    this.showFlags = true,
    this.labelText = 'Convention List *',
    this.hintText = 'Select a convention',
    this.readOnly = false,
    this.padding = const EdgeInsets.all(16),
    this.showActiveOnly = true,
  });

  @override
  State<DepreciationConventionSelector> createState() =>
      _DepreciationConventionSelectorState();
}

class _DepreciationConventionSelectorState
    extends State<DepreciationConventionSelector> {
  DepreciationConvention? _selectedConvention;

  @override
  void initState() {
    super.initState();
    _selectedConvention = widget.initialConvention;
  }

  List<DepreciationConvention> get _filteredConventions {
    if (widget.showActiveOnly) {
      return widget.conventions.where((c) => c.isActive).toList();
    }
    return widget.conventions;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Convention Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.labelText!,
                style: const TextStyle(
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
                child: DropdownButtonFormField<DepreciationConvention>(
                  value: _selectedConvention,
                  isExpanded: true,
                  hint: Text(widget.hintText!),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: _filteredConventions.map((convention) {
                    return DropdownMenuItem(
                      value: convention,
                      child: Text(
                        convention.displayName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: convention.isActive
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: widget.readOnly
                      ? null
                      : (newValue) {
                          setState(() {
                            _selectedConvention = newValue;
                          });
                          widget.onConventionChanged(newValue);
                        },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a convention';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),

          if (_selectedConvention != null && widget.showFlags) ...[
            const SizedBox(height: 20),

            // Behavior Flags Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Behavior Flags:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: [
                      _buildFlagRow(
                        'Apply Pro-rata on Acquisition:',
                        _selectedConvention!.flags['proRataAcq'] ?? false,
                      ),
                      const Divider(height: 1),
                      _buildFlagRow(
                        'Apply Pro-rata on Disposal:',
                        _selectedConvention!.flags['proRataDisp'] ?? false,
                      ),
                      const Divider(height: 1),
                      _buildFlagRow(
                        'Full Depreciation in Acquisition Yr:',
                        _selectedConvention!.flags['fullDepAcq'] ?? false,
                      ),
                      const Divider(height: 1),
                      _buildFlagRow(
                        'No Depreciation in Disposal Yr:',
                        _selectedConvention!.flags['noDepDisp'] ?? false,
                      ),
                      const Divider(height: 1),
                      _buildFlagRow(
                        'Start From Next Financial Year:',
                        _selectedConvention!.flags['startNextFinYear'] ?? false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          if (_selectedConvention != null && widget.showNotes) ...[
            const SizedBox(height: 20),

            // Notes Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notes:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _selectedConvention!.notes,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),

          if (_selectedConvention == null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[800], size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Please select a convention from the dropdown to view its behavior flags and notes.',
                      style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFlagRow(String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: value,
                        onChanged: null,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        fillColor: MaterialStateProperty.all(Colors.blue[800]),
                      ),
                      const Text('Yes', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: value,
                        onChanged: null,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        fillColor: MaterialStateProperty.all(Colors.blue[800]),
                      ),
                      const Text('No', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Main Form that uses the reusable selector
class DepreciationConventionForm extends StatefulWidget {
  const DepreciationConventionForm({super.key});

  @override
  State<DepreciationConventionForm> createState() =>
      _DepreciationConventionFormState();
}

class _DepreciationConventionFormState
    extends State<DepreciationConventionForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService(); // Initialize API service

  // List of conventions
  final List<DepreciationConvention> conventions = const [
    DepreciationConvention(
      value: 'Exact Date (IFRS - Daily Pro-rata)',
      displayName: 'Exact Date (IFRS - Daily Pro-rata)',
      flags: {
        'proRataAcq': true,
        'proRataDisp': true,
        'fullDepAcq': false,
        'noDepDisp': false,
        'startNextFinYear': false,
      },
      notes:
          'Daily pro‑rata depreciation on both acquisition and disposal dates. Full year is prorated by actual number of days used.',
      isActive: true,
    ),
    DepreciationConvention(
      value: 'Monthly Pro-rata',
      displayName: 'Monthly Pro-rata',
      flags: {
        'proRataAcq': true,
        'proRataDisp': true,
        'fullDepAcq': false,
        'noDepDisp': false,
        'startNextFinYear': false,
      },
      notes:
          'Monthly pro‑rata depreciation; acquisition and disposal months are prorated based on number of months used.',
      isActive: true,
    ),
    DepreciationConvention(
      value: 'Full-Year Convention - No Acquisition Year',
      displayName: 'Full-Year Convention - No Acquisition Year',
      flags: {
        'proRataAcq': false,
        'proRataDisp': false,
        'fullDepAcq': false,
        'noDepDisp': false,
        'startNextFinYear': true,
      },
      notes:
          'No depreciation in acquisition year; depreciation starts from the next financial year with full-year depreciation.',
      isActive: true,
    ),
    DepreciationConvention(
      value: 'Full-Year Convention - No Disposal Year',
      displayName: 'Full-Year Convention - No Disposal Year',
      flags: {
        'proRataAcq': false,
        'proRataDisp': false,
        'fullDepAcq': true,
        'noDepDisp': true,
        'startNextFinYear': false,
      },
      notes:
          'Full depreciation in acquisition year; zero depreciation in disposal year.',
      isActive: true,
    ),
    DepreciationConvention(
      value: 'Half-Year Convention',
      displayName: 'Half-Year Convention',
      flags: {
        'proRataAcq': false,
        'proRataDisp': false,
        'fullDepAcq': false,
        'noDepDisp': false,
        'startNextFinYear': false,
      },
      notes:
          'Half-year depreciation is applied in both acquisition and disposal years; remaining years receive full-year depreciation.',
      isActive: true,
    ),
  ];

  // Selected convention
  DepreciationConvention? _selectedConvention;
  bool _isLoading = false;
  List<Convention> _existingConventions = []; // Cache for existing conventions

  @override
  void initState() {
    super.initState();
    _loadExistingConventions();
  }

  // Load existing conventions to check for duplicates
  Future<void> _loadExistingConventions() async {
    try {
      // You'll need to implement a GET method in your ApiService to fetch existing conventions
      final conventions = await _apiService.getConventions();
      setState(() {
        _existingConventions = conventions;
      });
    } catch (e) {
      print('Error loading existing conventions: $e');
    }
  }

  // Check for duplicate convention name
  bool _isDuplicateConventionName(String conventionName) {
    return _existingConventions.any(
      (convention) =>
          convention.conventionName.toLowerCase() ==
          conventionName.toLowerCase(),
    );
  }

  // Save form method with API integration
  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedConvention == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a convention'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Check for duplicate convention name
      if (_isDuplicateConventionName(_selectedConvention!.displayName)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Convention "${_selectedConvention!.displayName}" already exists. Please use a different name.',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Convert selected convention to Convention model
        final newConvention = _selectedConvention!.toConvention();

        // Call API to post the convention
        await _apiService.postConvention(newConvention);

        // Refresh the list of existing conventions
        await _loadExistingConventions();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully saved: ${_selectedConvention!.displayName}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear the form after successful save
        _clearForm();
      } catch (e) {
        // Handle API errors
        String errorMessage = 'Error saving convention';

        if (e.toString().contains('409') ||
            e.toString().contains('duplicate')) {
          errorMessage = 'A convention with this name already exists';
        } else if (e.toString().contains('Failed to post')) {
          errorMessage = 'Failed to connect to the server';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );

        print('Error saving convention: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // ... rest of your existing methods (_showAddConventionDialog, _showEditConventionDialog,
  // _showDisableConfirmation, _clearForm, etc.) remain the same ...

  void _showAddConventionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Convention'),
        content: const Text('Add new convention functionality here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add convention - To be implemented'),
                ),
              );
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditConventionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Convention'),
        content: Text('Edit: ${_selectedConvention?.displayName}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit convention - To be implemented'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDisableConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Convention'),
        content: Text(
          'Are you sure you want to disable "${_selectedConvention?.displayName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = conventions.indexOf(_selectedConvention!);
                if (index != -1) {
                  final disabledConvention = _selectedConvention!.copyWith(
                    isActive: false,
                  );
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_selectedConvention?.displayName} has been disabled',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    setState(() {
      _selectedConvention = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Depreciation Convention Master',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reusable Convention Selector
                  DepreciationConventionSelector(
                    initialConvention: _selectedConvention,
                    conventions: conventions,
                    onConventionChanged: (convention) {
                      setState(() {
                        _selectedConvention = convention;
                      });
                    },
                    showButtons: false,
                  ),

                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveForm,
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

                  const SizedBox(height: 20),

                  // Management Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _showAddConventionDialog();
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue[800],
                          size: 20,
                        ),
                        label: Text(
                          'Add New Convention',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      TextButton.icon(
                        onPressed: _selectedConvention != null
                            ? () {
                                _showEditConventionDialog();
                              }
                            : null,
                        icon: Icon(
                          Icons.edit,
                          color: _selectedConvention != null
                              ? Colors.blue[800]
                              : Colors.grey,
                          size: 20,
                        ),
                        label: Text(
                          'Edit',
                          style: TextStyle(
                            color: _selectedConvention != null
                                ? Colors.blue[800]
                                : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: Colors.grey.shade300,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      TextButton.icon(
                        onPressed: _selectedConvention != null
                            ? () {
                                _showDisableConfirmation();
                              }
                            : null,
                        icon: Icon(
                          Icons.block,
                          color: _selectedConvention != null
                              ? Colors.red
                              : Colors.grey,
                          size: 20,
                        ),
                        label: Text(
                          'Disable',
                          style: TextStyle(
                            color: _selectedConvention != null
                                ? Colors.red
                                : Colors.grey,
                            fontSize: 14,
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
}

// class ConventionListScreen extends StatefulWidget {
//   @override
//   _ConventionListScreenState createState() => _ConventionListScreenState();
// }

// class _ConventionListScreenState extends State<ConventionListScreen> {
//   late Future<List<Convention>> futureConventions;

//   @override
//   void initState() {
//     super.initState();
//     futureConventions = ApiService().getConventions();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Depreciation Conventions Overview"),
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black87,
//         elevation: 0.5,
//       ),
//       body: FutureBuilder<List<Convention>>(
//         future: futureConventions,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text("No data found"));
//           }

//           List<Convention> conventions = snapshot.data!;

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Compare behavior across different asset depreciation conventions.",
//                   style: TextStyle(color: Colors.grey[600], fontSize: 14),
//                 ),
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           headingRowColor: MaterialStateProperty.all(
//                             Colors.grey[50],
//                           ),
//                           columnSpacing: 30,
//                           columns: const [
//                             DataColumn(
//                               label: Text(
//                                 'No.',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Convention Name',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Apply Prorata\nAcquisition',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Apply Prorata\nDisposal',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Full Depre in\nAcquisition Yr',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'No Depre in\nDisposal Yr',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Next Fin Yr\nStart',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             DataColumn(
//                               label: Text(
//                                 'Note',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ],
//                           rows: List<DataRow>.generate(conventions.length, (
//                             index,
//                           ) {
//                             final item = conventions[index];
//                             return DataRow(
//                               cells: [
//                                 DataCell(Text((index + 1).toString())),
//                                 DataCell(
//                                   Text(
//                                     item.conventionName,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ),
//                                 DataCell(
//                                   _buildStatusIcon(
//                                     item.applyProrataAcquisition,
//                                   ),
//                                 ),
//                                 DataCell(
//                                   _buildStatusIcon(item.applyProrataDisposal),
//                                 ),
//                                 DataCell(
//                                   _buildStatusIcon(
//                                     item.fullDepreInAcquisitionYear,
//                                   ),
//                                 ),
//                                 DataCell(
//                                   _buildStatusIcon(item.noDepreInDisposalYear),
//                                 ),
//                                 DataCell(
//                                   _buildStatusIcon(
//                                     item.startFromNextFinancialYear,
//                                   ),
//                                 ),
//                                 DataCell(
//                                   Container(
//                                     constraints: BoxConstraints(maxWidth: 200),
//                                     child: Text(
//                                       item.note,
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatusIcon(bool status) {
//     return Center(
//       child: Icon(
//         status ? Icons.check_circle : Icons.cancel,
//         color: status ? Colors.green : Colors.red[300],
//         size: 20,
//       ),
//     );
//   }
// }

// Alternative implementation using PlutoGrid for better performance and features
class ConventionGridScreen extends StatefulWidget {
  @override
  _ConventionGridScreenState createState() => _ConventionGridScreenState();
}

class _ConventionGridScreenState extends State<ConventionGridScreen> {
  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  late PlutoGridStateManager stateManager;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initColumns();
    _loadData();
  }

  void _initColumns() {
    columns = [
      PlutoColumn(
        title: 'Convention Name',
        field: 'name',
        type: PlutoColumnType.text(),
        width: 250,
        enableEditingMode: false,
        renderer: (rendererContext) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(vertical: 8.0),
              child: Text(
                rendererContext.cell.value.toString(),
                style: TextStyle(fontSize: 14),
                softWrap: true,
              ),
            ),
          );
        },
      ),
      // Boolean columns with custom renderer for Icons
      _buildBoolColumn('Apply Prorata (Acq)', 'apply_acq'),
      _buildBoolColumn('Apply Prorata (Disp)', 'apply_disp'),
      _buildBoolColumn('Full Depre (Acq Yr)', 'full_acq'),
      _buildBoolColumn('No Depre (Disp Yr)', 'no_disp'),
      _buildBoolColumn('Next Fin Yr Start', 'next_fy'),

      PlutoColumn(
        title: 'Note',
        field: 'note',
        type: PlutoColumnType.text(),
        width: 400,
        enableFilterMenuItem: false,
        enableContextMenu: false,
        enableEditingMode: false,
        renderer: (rendererContext) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(vertical: 8.0),
              child: Text(
                rendererContext.cell.value.toString(),
                style: TextStyle(fontSize: 14),
                softWrap: true,
              ),
            ),
          );
        },
      ),
    ];
  }

  // Helper to create Boolean columns with Icons
  PlutoColumn _buildBoolColumn(String title, String field) {
    return PlutoColumn(
      title: title,
      field: field,
      type: PlutoColumnType.text(), // We use text type but render icons
      width: 160,
      textAlign: PlutoColumnTextAlign.center,
      enableEditingMode: false,
      renderer: (rendererContext) {
        bool val = rendererContext.cell.value == 'true';
        return Icon(
          val ? Icons.check_circle : Icons.cancel,
          color: val ? Colors.green : Colors.red[300],
          size: 20,
        );
      },
    );
  }

  Future<void> _loadData() async {
    try {
      final data = await ApiService().getConventions();
      setState(() {
        rows = data.asMap().entries.map((entry) {
          int idx = entry.key;
          var item = entry.value;
          return PlutoRow(
            cells: {
              'name': PlutoCell(value: item.conventionName),
              'apply_acq': PlutoCell(
                value: item.applyProrataAcquisition.toString(),
              ),
              'apply_disp': PlutoCell(
                value: item.applyProrataDisposal.toString(),
              ),
              'full_acq': PlutoCell(
                value: item.fullDepreInAcquisitionYear.toString(),
              ),
              'no_disp': PlutoCell(
                value: item.noDepreInDisposalYear.toString(),
              ),
              'next_fy': PlutoCell(
                value: item.startFromNextFinancialYear.toString(),
              ),
              'note': PlutoCell(value: item.note),
            },
          );
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      // Handle Error
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: PlutoGrid(
                columns: columns,
                rows: rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  stateManager.setShowColumnFilter(false);
                },
                configuration: PlutoGridConfiguration(
                  style: PlutoGridStyleConfig(
                    gridBorderRadius: BorderRadius.circular(8),
                    columnTextStyle: TextStyle(fontWeight: FontWeight.bold),
                    rowHeight: 80,
                  ),
                ),
              ),
            ),
    );
  }
}
