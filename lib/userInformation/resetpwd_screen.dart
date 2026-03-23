import 'package:fixed_asset_frontend/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ResetPasswordPage(),
    )
  );
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
    final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isLoading = false;
   bool obscure = true;

  Future<void> resetPassword() async {
    final fullUri = Uri.parse(Uri.base.toString().replaceFirst('#/', ''));
  final token = fullUri.queryParameters['token'];
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid link")),
      );
      return;
    }

    if (passwordController.text != confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api/reset-password/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "new_password": passwordController.text,
      }),
    );

    setState(() => isLoading = false);

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Password reset successful")),
      );
      
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["error"] ?? "Failed to reset password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFFF5F6FA),
     // appBar: AppBar(title: const Text("Reset Password")),
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
            width: 300,
            height: 350,
            child: Column(
              children: [
                 const Icon(Icons.lock, size: 40, color: Color.fromARGB(255, 25, 115, 219)),
                  const SizedBox(height: 10),

                Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 25),
                CustomTextfield(
                      hint: "New Password",
                      controller: passwordController,
                      obscure: obscure,
                      suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                      onSuffixTap: () => setState(() => obscure = !obscure),
                    ),
                SizedBox(height: 15),
                CustomTextfield(
                      hint: "Confirm Password",
                      controller: confirmController,
                      obscure: obscure,
                      suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                      onSuffixTap: () => setState(() => obscure = !obscure),
                    ),
                  
                
                SizedBox(height: 30),
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
                    onPressed: isLoading ? null : resetPassword,
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Update"),
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