import 'package:fixed_asset_frontend/system_default/system_default_component.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookLevelDepreciation(),
    ),
  );
}

class BookLevelDepreciation extends StatefulWidget {
  const BookLevelDepreciation({super.key});

  @override
  State<BookLevelDepreciation> createState() => _BookLevelDepreciationState();
}

class _BookLevelDepreciationState extends State<BookLevelDepreciation> {
  final _formKey = GlobalKey<FormState>();
  final List<String> bookLevels = ["Tax Book", "IFRS Book", "Management Book"];
  double labelWidth = 250;

  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Book Level Policy",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromARGB(255, 236, 236, 236),
                  width: 1.5,
                ), // Visible Border
              ),
              width: 1000,
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Book Level Policy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// Book Level Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: labelWidth,
                          child: const Text(
                            "Book Level",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: DropdownButtonFormField<String>(
                            value: selectedLevel,
                            decoration: const InputDecoration(
                              hintText: "Select Book Level",
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                            items: bookLevels.map((level) {
                              return DropdownMenuItem<String>(
                                value: level,
                                child: Text(level),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedLevel = value;
                              });
                            },
                            validator: (value) => value == null
                                ? "Please select book level"
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// Panels
                  const DepreciationSettingsPanel(),
                  //const SizedBox(height: 5),
                  const DefaultStartRulePanel(),
                  //const SizedBox(height: 5),
                  const DefaultConventionPanel(),
                  const SizedBox(height: 5),
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
