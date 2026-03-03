import 'package:fixed_asset_frontend/system_default/system_default_component.dart';
import 'package:flutter/material.dart';

class BookLevelDepreciation extends StatefulWidget {
  const BookLevelDepreciation({super.key});

  @override
  State<BookLevelDepreciation> createState() => _BookLevelDepreciationState();
}

class _BookLevelDepreciationState extends State<BookLevelDepreciation> {
  final List<String> bookLevels = ["Tax", "IFRS", "Management"];

  // Selected value
  String? selectedLevel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Book Level Policy",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Container(
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Level",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    value: selectedLevel,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    hint: Text("Select Book Level"),
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
                  ),
                ),
                SizedBox(height: 8),
                const SizedBox(height: 20),
                DepreciationMainPanel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
