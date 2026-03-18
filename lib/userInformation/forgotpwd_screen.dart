import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ForgotPasswordPage(),
    )
  );
}
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendResetLink() async {
    setState(() => isLoading = true);

    final url = Uri.parse("https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api/forgot-password/"); 
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": emailController.text}),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Reset link sent")),
      );
      
      Navigator.pop(context);
    } else {
      print("Status Code: ${response.statusCode}"); 
  print("Response Body: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending reset link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
     // appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            width: 350,
            height: 300,
            child: Column(
              children: [
                const Icon(Icons.email_outlined, size: 40, color:  Color(0xFF1967D2)),
                  const SizedBox(height: 10),

                Text(
                  "Enter your email to receive a password reset link.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1967D2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                    onPressed: isLoading ? null : sendResetLink,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}