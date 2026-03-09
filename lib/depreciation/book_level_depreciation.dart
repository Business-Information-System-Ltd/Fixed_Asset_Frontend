import 'package:fixed_asset_frontend/system_default/system_default_component.dart';
import 'package:flutter/material.dart';
import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';

extension SystemDefaultToBookPolicy on SystemDefault {
  BookPolicy toBookPolicy(BookPolicy originalPolicy) {
    return BookPolicy(
      bookLevelPolicyId: originalPolicy.bookLevelPolicyId,
      bookLevel: originalPolicy.bookLevel,
      depreciationFrequency: depreciationFrequency,
      postingDateRule: postingDateRule,
      roundingPrecision: roundingPrecision.toDouble(),

      preventNegativeNBV: preventNegativeNbv,
      stopAtResidualValue: stopResidualValue,
      periodLockRequired: periodLockRequired,
      allowPostingToClosedPeriod: allowPostingClosedPeriod,

      depreciationStartRule: startRule,
      depreciationnConvention: convention,
      createdAt: originalPolicy.createdAt,
      book: originalPolicy.book,
      defaultId: originalPolicy.defaultId,
      convention: originalPolicy.convention,
    );
  }
}
class BookLevelDepreciation extends StatefulWidget {
  final String? bookLevel;
  final bool readOnly;

  const BookLevelDepreciation({
    super.key,
    this.bookLevel,
    this.readOnly = false,
  });

  @override
  State<BookLevelDepreciation> createState() => _BookLevelDepreciationState();
}

class _BookLevelDepreciationState extends State<BookLevelDepreciation> {
  final _formKey = GlobalKey<FormState>();
  final List<String> bookLevels = ["Tax", "IFRS", "Management"];

  String? selectedLevel;
  bool isEdit = false;
  bool isLoading = true;
  BookPolicy? currentPolicy;
  List<BookPolicy> allPolicies = [];
  SystemDefault? data;
  SystemDefault? originalData;
  final precisionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final policies = await ApiService().fetchBookLevel();
      setState(() {
        allPolicies = policies;
        isLoading = false;
        if (allPolicies.isNotEmpty) {
          if (widget.bookLevel != null) {
            _onBookLevelChanged(widget.bookLevel);
          } else {
            _onBookLevelChanged(allPolicies.first.bookLevel);
          }
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading data: $e");
    }
  }

  void _onBookLevelChanged(String? level) {
    if (level == null) return;

    final policy = allPolicies.firstWhere(
      (p) => p.bookLevel == level,
      orElse: () => allPolicies.first,
    );

    String formatBool(dynamic value) {
      if (value == null) return "No";
      if (value is bool) return value ? "Yes" : "No";
      if (value.toString().toLowerCase() == "true") return "Yes";
      return "No";
    }

    setState(() {
      selectedLevel = level;
      currentPolicy = policy;
      isEdit = false;

      data = SystemDefault(
        defaultId: policy.defaultId,
        depreciationFrequency: policy.depreciationFrequency ?? "Monthly",
        postingDateRule: policy.postingDateRule,
        roundingPrecision: policy.roundingPrecision?.toInt() ?? 2,

        preventNegativeNbv: formatBool(policy.preventNegativeNBV),
        stopResidualValue: formatBool(policy.stopAtResidualValue),
        periodLockRequired: formatBool(policy.periodLockRequired),
        allowPostingClosedPeriod: formatBool(policy.allowPostingToClosedPeriod),

        startRule: policy.depreciationStartRule,
        convention: policy.depreciationnConvention,
      );

      precisionController.text = policy.roundingPrecision?.toString() ?? "2";
    });
  }

  Future<void> _saveData() async {
    if (currentPolicy == null || data == null) return;

    setState(() => isLoading = true);

    try {
      final updatedPolicy = data!.toBookPolicy(currentPolicy!);
      await ApiService().updateBookLevel(
        updatedPolicy.bookLevelPolicyId,
        updatedPolicy,
      );

      setState(() {
        isEdit = false;
        currentPolicy = updatedPolicy;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book Level Policy saved successfully!")),
      );
    } catch (e) {
      debugPrint("Error saving data: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void cancelEdit() {
    setState(() {
      isEdit = false;
      data = SystemDefault.fromJson(originalData!.toJson());
      precisionController.text = data!.roundingPrecision.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              child: Column(
                children: [
                  _buildBookLevelHeader(),
                  const SizedBox(height: 10),

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

                  // const SizedBox(height: 20),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildBookLevelHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Book Level Policy',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Book Level:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 250,
                child: TextFormField(
                  readOnly: true,
                  initialValue: widget.bookLevel ?? "Tax Book",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    if (!isEdit) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () => setState(() => isEdit = true),
          icon: const Icon(Icons.edit, size: 18),
          label: const Text("Edit "),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          // onPressed: () {
          //   _onBookLevelChanged(selectedLevel);
          // },
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Save "),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed: cancelEdit,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
