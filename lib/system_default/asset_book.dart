import 'package:flutter/material.dart';

class assetBook extends StatefulWidget {
  const assetBook({super.key});

  @override
  State<assetBook> createState() => _assetBookState();
}

class _assetBookState extends State<assetBook> {
  final _formKey = GlobalKey<FormState>();
  bool enableMultiBook = true;
  List<bool> bookStatus = [true, true, false];

  void _updatebookStatus(bool value) {
    setState(() {
      enableMultiBook = value;

      if (value) {
        bookStatus = [true, true, false];
      } else {
        bookStatus = [false, false, false];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      // appBar: AppBar(
      //   title: const Text('Asset Books'),
      //   centerTitle: true,
      //   backgroundColor: Colors.blue[800],
      //   foregroundColor: Colors.white,
      // ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            width: 550,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "ASSET BOOKS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Enable Multi Book
                const Text(
                  "Enable Multi-Book:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: enableMultiBook,
                      onChanged: (value) {
                        if (value != null) _updatebookStatus(value);
                      },
                    ),
                    const Text("Yes"),
                    const SizedBox(width: 20),
                    Radio<bool>(
                      value: false,
                      groupValue: enableMultiBook,
                      onChanged: (value) {
                        if (value != null) _updatebookStatus(value);
                      },
                    ),
                    const Text("No"),
                  ],
                ),

                const Divider(height: 30),

                // Books
                const Text(
                  "Books :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                _buildBookRow("1. IFRS Book", bookStatus[0]),
                _buildBookRow("2. Tax Book", bookStatus[1]),
                _buildBookRow("3. Management Book", bookStatus[2]),

                const SizedBox(height: 30),

                // Buttons
                Container(
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        //icon: const Icon(Icons.add),
                        label: const Text("Add Book"),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton.icon(
                        onPressed: () {},
                        //icon: const Icon(Icons.edit),
                        label: const Text("Edit Book"),
                      ),
                      const Spacer(),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookRow(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isActive ? "Active" : "Inactive",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
