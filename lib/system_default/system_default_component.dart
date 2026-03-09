import 'package:flutter/material.dart';
import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';

class DepreciationMainPanel extends StatefulWidget {
  const DepreciationMainPanel({super.key});

  @override
  State<DepreciationMainPanel> createState() => _DepreciationMainPanelState();
}

class _DepreciationMainPanelState extends State<DepreciationMainPanel> {
  bool isEdit = false;
  bool isLoading = true;
    final _formKey = GlobalKey<FormState>();


  SystemDefault? data;
  SystemDefault? originalData;

  final precisionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  SystemDefault createInitialData() {
    return SystemDefault(
      defaultId: 0,
      depreciationFrequency: "Monthly",
      postingDateRule: "End of Month",
      roundingPrecision: 2,
      preventNegativeNbv: "No",
      stopResidualValue: "No",
      periodLockRequired: "No",
      allowPostingClosedPeriod: "No",
      startRule: "From Capitalization Date",
      convention: "Exact Date (IFRS - Daily Pro-rata)",
    );
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      List<SystemDefault> result = await ApiService().fetchSystemDefault();
      if (result.isNotEmpty) {
        data = result.first;
      } else {
        data = createInitialData();
      }
      originalData = SystemDefault.fromJson(data!.toJson());
      precisionController.text = data!.roundingPrecision.toString();
    } catch (e) {
      data = createInitialData();
    }
    setState(() => isLoading = false);
  }

  void enableEdit() {
    setState(() => isEdit = true);
  }

  void cancelEdit() {
    setState(() {
      isEdit = false;
      data = SystemDefault.fromJson(originalData!.toJson());
      precisionController.text = data!.roundingPrecision.toString();
    });
  }

  Future<void> handleSave() async {
    if (data == null) return;
    setState(() => isLoading = true);
    try {
      data!.roundingPrecision = (int.tryParse(precisionController.text) ?? 0);
      if (data!.defaultId == 0) {
        await ApiService().postSystemDefault(data!);
      } else {
        await ApiService().updateSystemDefault(data!.defaultId, data!);
      }
      originalData = SystemDefault.fromJson(data!.toJson());
      setState(() => isEdit = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated successfully!")));
      loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Form(
      key: _formKey,
      child: Center(
        
        child: Container(
          color: Colors.white, 
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                const Text(
              "System Default",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 12),

                _buildSection(
                  title: "Depreciation Settings",
                  child: DepreciationSettingsPanel(
                    data: data!,
                    isEdit: isEdit,
                    precisionController: precisionController,
                    onUpdate: (updated) => setState(() => data = updated),
                  ),
                ),
                _buildSection(
                  title: "Default Depreciation Start Rule",
                  child: DefaultStartRulePanel(
                    startRule: data!.startRule,
                    isEdit: isEdit,
                    onUpdate: (val) => setState(() => data!.startRule = val),
                  ),
                ),
                _buildSection(
                  title: "Default Depreciation Convention",
                  child: DefaultConventionPanel(
                    convention: data!.convention,
                    isEdit: isEdit,
                    onUpdate: (val) => setState(() => data!.convention = val),
                  ),
                ),
                const SizedBox(height: 20),
                _buildActionButtons(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!, width: 1), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
            ),
          ),
          const Divider(thickness: 0.5, height: 20), 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (!isEdit) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: enableEdit,
          icon: const Icon(Icons.edit, size: 18),
          label: const Text("Edit "),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("Save"),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: cancelEdit,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            side: BorderSide(color: Colors.grey[400]!),
          ),
          child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}


class DepreciationSettingsPanel extends StatelessWidget {
  final SystemDefault data;
  final bool isEdit;
  final TextEditingController precisionController;
  final Function(SystemDefault) onUpdate;

  const DepreciationSettingsPanel({super.key, required this.data, required this.isEdit, required this.precisionController, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow("Frequency", ["Monthly", "Quarterly", "Annually"], data.depreciationFrequency, (v) {
          data.depreciationFrequency = v!;
          onUpdate(data);
        }),
        _buildRow("Posting Date Rule", ["End of Month", "Last Working Day", "Custom"], data.postingDateRule, (v) {
          data.postingDateRule = v!;
          onUpdate(data);
        }),
        _buildTextRow("Rounding Precision", precisionController),
        _buildRow("Prevent Negative NBV", ["Yes", "No"], data.preventNegativeNbv, (v) {
          data.preventNegativeNbv = v!;
          onUpdate(data);
        }),
        _buildRow("Stop at Residual Value", ["Yes", "No"], data.stopResidualValue, (v) {
          data.stopResidualValue = v!;
          onUpdate(data);
        }),
        _buildRow("Period Lock Required", ["Yes", "No"], data.periodLockRequired, (v) {
          data.periodLockRequired = v!;
          onUpdate(data);
        }),
        _buildRow("Allow Posting to Closed Period", ["Yes", "No"], data.allowPostingClosedPeriod, (v) {
          data.allowPostingClosedPeriod = v!;
          onUpdate(data);
        }),
      ],
    );
  }

  Widget _buildRow(String label, List<String> options, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontSize: 13))),
          Expanded(
            flex: 7,
            child: Wrap(
              spacing: 20,
              children: options.map((opt) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: opt,
                    groupValue: value,
                    onChanged: isEdit ? onChanged : null,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(opt, style: TextStyle(fontSize: 13, color: isEdit ? Colors.black : Colors.grey[600])),
                ],
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontSize: 13))),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 170,
                child: TextField(
                  controller: controller,
                  enabled: isEdit,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "Enter a decimal number",
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultStartRulePanel extends StatelessWidget {
  final String startRule;
  final bool isEdit;
  final Function(String) onUpdate;

  const DefaultStartRulePanel({super.key, required this.startRule, required this.isEdit, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final options = ["From Capitalization Date", "From Ready-for-Use Date", "From Beginning of Next Period", "From Beginning of Next Financial Year"];
    return Column(
      children: options.map((e) => RadioListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        value: e,
        groupValue: startRule,
        onChanged: isEdit ? (val) => onUpdate(val as String) : null,
        title: Text(e, style: const TextStyle(fontSize: 14)),
      )).toList(),
    );
  }
}

class DefaultConventionPanel extends StatelessWidget {
  final String convention;
  final bool isEdit;
  final Function(String) onUpdate;

  const DefaultConventionPanel({super.key, required this.convention, required this.isEdit, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final options = ["Exact Date (IFRS - Daily Pro-rata)", "Monthly Pro-rata", "Full-Year Convention - No Acquisition Year", "Full-Year Convention - No Disposal Year", "Half-Year Convention"];
    return Column(
      children: options.map((e) => RadioListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        value: e,
        groupValue: convention,
        onChanged: isEdit ? (val) => onUpdate(val as String) : null,
        title: Text(e, style: const TextStyle(fontSize: 14)),
      )).toList(),
    );
  }
}