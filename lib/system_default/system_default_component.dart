import 'package:flutter/material.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: DepreciationMainPanel(),
//     ),
//   );
// }

class DepreciationMainPanel extends StatelessWidget {
  const DepreciationMainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   backgroundColor: Colors.grey[100],
    //   appBar: AppBar(
    //     title:  Text("SYSTEM DEFAULTS"),
    //     centerTitle: true,
    //     backgroundColor: Colors.blue,
    //   ),
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DepreciationSettingsPanel(),
        SizedBox(height: 5),
        DefaultStartRulePanel(),
        SizedBox(height: 5),
        DefaultConventionPanel(),
        SizedBox(height: 20),

        /// Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  color: Color.fromARGB(255, 230, 221, 221),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            OutlinedButton(onPressed: () {}, child: const Text("Reset")),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {},
              child: const Text("View Audit Log"),
            ),
          ],
        ),
      ],
    );
  }
}

//// ================= PANEL 1 =================
class DepreciationSettingsPanel extends StatefulWidget {
  const DepreciationSettingsPanel({super.key});

  @override
  State<DepreciationSettingsPanel> createState() =>
      _DepreciationSettingsPanelState();
}

class _DepreciationSettingsPanelState extends State<DepreciationSettingsPanel> {
  String frequency = "Monthly";
  String postingRule = "End of Month";
  String preventNBV = "Yes";
  String stopResidual = "Yes";
  String periodLock = "Yes";
  String allowClosed = "No";

  @override
  Widget build(BuildContext context) {
    return buildCard(
      title: "Depreciation Settings",
      child: Column(
        children: [
          buildRadioRow(
            "Depreciation Frequency",
            ["Monthly", "Quarterly", "Annually"],
            frequency,
            (val) => setState(() => frequency = val!),
          ),

          buildRadioRow(
            "Posting Date Rule",
            ["End of Month", "Last Working Day", "Custom"],
            postingRule,
            (val) => setState(() => postingRule = val!),
          ),

          buildTextFieldRow("Posting Precision", "Enter decimal number"),

          buildRadioRow(
            "Prevent Negative NBV",
            ["Yes", "No"],
            preventNBV,
            (val) => setState(() => preventNBV = val!),
          ),

          buildRadioRow(
            "Stop at Residual Value",
            ["Yes", "No"],
            stopResidual,
            (val) => setState(() => stopResidual = val!),
          ),

          buildRadioRow(
            "Period Lock Required",
            ["Yes", "No"],
            periodLock,
            (val) => setState(() => periodLock = val!),
          ),

          buildRadioRow(
            "Allow Posting to Closed Period",
            ["Yes", "No"],
            allowClosed,
            (val) => setState(() => allowClosed = val!),
          ),
        ],
      ),
    );
  }
}

//// ================= PANEL 2 =================
class DefaultStartRulePanel extends StatefulWidget {
  const DefaultStartRulePanel({super.key});

  @override
  State<DefaultStartRulePanel> createState() => _DefaultStartRulePanelState();
}

class _DefaultStartRulePanelState extends State<DefaultStartRulePanel> {
  String startRule = "From Capitalization Date";

  @override
  Widget build(BuildContext context) {
    return buildCard(
      title: "Default Depreciation Start Rule",
      child: Column(
        children:
            [
              "From Capitalization Date",
              "From Ready-for-Use Date",
              "From Beginning of Next Period",
              "From Beginning of Next Financial Year",
            ].map((e) {
              return RadioListTile(
                value: e,
                groupValue: startRule,
                onChanged: (val) => setState(() => startRule = val!),
                title: Text(e),
              );
            }).toList(),
      ),
    );
  }
}

//// ================= PANEL 3 =================
class DefaultConventionPanel extends StatefulWidget {
  const DefaultConventionPanel({super.key});

  @override
  State<DefaultConventionPanel> createState() => _DefaultConventionPanelState();
}

class _DefaultConventionPanelState extends State<DefaultConventionPanel> {
  String convention = "Exact Date (IFRS - Daily Pro-rata)";

  @override
  Widget build(BuildContext context) {
    return buildCard(
      title: "Default Depreciation Convention",
      child: Column(
        children:
            [
              "Exact Date (IFRS - Daily Pro-rata)",
              "Monthly Pro-rata",
              "Full-Year Convention - No Acquisition Year",
              "Full-Year Convention - No Disposal Year",
              "Half-Year Convention",
            ].map((e) {
              return RadioListTile(
                value: e,
                groupValue: convention,
                onChanged: (val) => setState(() => convention = val!),
                title: Text(e),
              );
            }).toList(),
      ),
    );
  }
}

Widget buildCard({required String title, required Widget child}) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(height: 10),
          child,
        ],
      ),
    ),
  );
}

Widget buildRadioRow(
  String label,
  List<String> options,
  String groupValue,
  Function(String?) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 250,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 20,
            runSpacing: 8,
            children: options.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: e,
                    groupValue: groupValue,
                    onChanged: onChanged,
                  ),
                  Text(e),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextFieldRow(String label, String hint) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        SizedBox(
          width: 250,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
      ],
    ),
  );
}
