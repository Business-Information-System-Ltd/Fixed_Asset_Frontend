import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/screens/dashboard.dart';
import 'package:fixed_asset_frontend/widgets/customTextField.dart';
import 'package:fixed_asset_frontend/widgets/googleAuthService.dart';
import 'package:fixed_asset_frontend/widgets/microsoftAuthService.dart';
import 'package:fixed_asset_frontend/widgets/socialButton.dart';
import 'package:flutter/material.dart';
import 'signup.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fixed_asset_frontend/api/api_service.dart';
//import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final apiService = ApiService();
  bool obscure = true;
  bool isLoggingIn = false;
  bool _isMicrosoftLoading = false;
  Future<void> _handleLogin() async {
    setState(() => isLoggingIn = true);

    try {
      final apiService = ApiService();

      final response = await apiService.loginUser(
        emailController.text,
        passwordController.text,
      );

      setState(() => isLoggingIn = false);

      if (response != null) {
        // final loginData = LoginResponse.fromJson(jsonDecode(response.body));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(userData: response),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Failed! Please check email/password."),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoggingIn = false);
      print("Login Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Login\nWelcome back!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                CustomTextfield(hint: "Email", controller: emailController),
                const SizedBox(height: 20),
                CustomTextfield(
                  hint: "Password",
                  controller: passwordController,
                  obscure: obscure,
                  suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                  onSuffixTap: () => setState(() => obscure = !obscure),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1967D2),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    onPressed: isLoggingIn ? null : _handleLogin,
                    child: isLoggingIn
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "LOGIN",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR", style: TextStyle(color: Colors.black)),
                    ),
                    Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Google
                    SocialIconButton(
                      assetPath: 'assets/google.png',
                      onTap: () async {
                        await GoogleAuthService().signInWithGoogle(context);
                      },
                    ),
                    const SizedBox(width: 15),

                    // Microsoft
                    _isMicrosoftLoading
                        ? const CircularProgressIndicator()
                        : SocialIconButton(
                            icon: FontAwesomeIcons.microsoft,
                            iconColor: const Color(0xFF00A4EF),
                            onTap: () async {
                              setState(() => _isMicrosoftLoading = true);
                              try {
                                AuthService authService = AuthService();
                                await authService.login();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login Error: $e")),
                                );
                              } finally {
                                if (mounted)
                                  setState(() => _isMicrosoftLoading = false);
                              }
                            },
                          ),
                    const SizedBox(width: 15),

                    // Facebook
                    SocialIconButton(
                      icon: FontAwesomeIcons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an acoount?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(color: Color(0xFF1967D2)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
