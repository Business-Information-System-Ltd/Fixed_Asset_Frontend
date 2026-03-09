import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/depreciation/book_level_depreciation.dart';
import 'package:flutter/material.dart';

class AssetBookScreen extends StatefulWidget {
  final Function(String)? onOpenBookLevel;

  const AssetBookScreen({super.key, this.onOpenBookLevel});

  @override
  State<AssetBookScreen> createState() => _AssetBookScreenState();
}

class _AssetBookScreenState extends State<AssetBookScreen> {
  final _formKey = GlobalKey<FormState>();

  bool enableMultiBook = true;
  bool isEdit = false;
  bool isLoading = true;

  List<AssetBook> books = [];
  List<AssetBook> originalBooks = [];
  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiService().fetchAssetBook();
      setState(() {
        books = data;
        if (books.isNotEmpty) {
          enableMultiBook = books[0].multiBookSupport;
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching data: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _enableEdit() {
    setState(() {
      isEdit = true;

      originalBooks = books
          .map(
            (b) => AssetBook(
              bookId: b.bookId,
              bookName: b.bookName,
              multiBookSupport: b.multiBookSupport,
              isActive: b.isActive,
            ),
          )
          .toList();
    });
  }

  void _cancelEdit() {
    setState(() {
      isEdit = false;
      books = originalBooks;
      enableMultiBook = books.isNotEmpty ? books[0].multiBookSupport : true;
    });
  }

  void _updateMultiBookStatus(bool value) {
    if (!isEdit) return;
    setState(() {
      enableMultiBook = value;
      for (var book in books) {
        book.multiBookSupport = value;
        if (!value) {
          book.isActive = false;
        } else {
          book.isActive = true;
        }
      }
    });
  }

  Future<void> _saveData() async {
    setState(() => isLoading = true);
    try {
      for (var book in books) {
        await ApiService().updateAssetBook(book.bookId, book);
      }
      setState(() => isEdit = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved Successfully!")));
    } catch (e) {
      print("Update Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Form(
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
                      _buildHeader(),
                      const SizedBox(height: 20),
                      const Text(
                        "Enable Multi-Book:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildRadioSection(),
                      const Divider(height: 30),
                      const Text(
                        "Books :",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...books.asMap().entries.map((entry) {
                        int index = entry.key;
                        AssetBook book = entry.value;
                        return _buildBookRow(book, index + 1);
                      }).toList(),
                      const SizedBox(height: 30),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _buildRadioSection() {
    return Row(
      children: [
        Radio<bool>(
          value: true,
          groupValue: enableMultiBook,
          onChanged: isEdit ? (value) => _updateMultiBookStatus(value!) : null,
        ),
        const Text("Yes"),
        const SizedBox(width: 20),
        Radio<bool>(
          value: false,
          groupValue: enableMultiBook,
          onChanged: isEdit ? (value) => _updateMultiBookStatus(value!) : null,
        ),
        const Text("No"),
      ],
    );
  }

  Widget _buildBookRow(AssetBook book, int serialNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "$serialNumber. ${book.bookName}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.blue),
            tooltip: "Book Policy",
            onPressed: () {
              if (!book.isActive) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Inactive Book"),
                    content: Text("${book.bookName} is inactive."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              } else {
                widget.onOpenBookLevel?.call(book.bookName);
              }
            },
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: book.isActive ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              book.isActive ? "Active" : "Inactive",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isEdit) ...[
          OutlinedButton.icon(
            onPressed: _enableEdit,
            icon: const Icon(Icons.edit),
            label: const Text("Edit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
            ),
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
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
          const SizedBox(width: 16),
          Center(
            child: OutlinedButton.icon(
              onPressed: _cancelEdit,
              //icon: const Icon(Icons.cancel),
              label: const Text("Cancel"),
            ),
          ),
        ],
      ],
    );
  }
}
