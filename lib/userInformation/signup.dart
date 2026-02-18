import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/userInformation/login.dart';
import 'package:fixed_asset_frontend/userinformation/login.dart'
    hide LoginScreen;
import 'package:fixed_asset_frontend/widgets/customTextField.dart';
import 'package:fixed_asset_frontend/widgets/googleAuthService.dart';
import 'package:fixed_asset_frontend/widgets/socialButton.dart';
import 'package:flutter/material.dart';
import 'package:fixed_asset_frontend/api/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: SignupScreen()));
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  List<Department> departments = [];
  List<Role> roles = [];
  bool loadingDept = true;
  bool loadingRole = true;
  int? selectedDepartmentId;
  final apiService = ApiService();
  bool obscure = true;
  String? selectedRole;
  int? selectedRoleId;
  bool isSubmitting = false;

  InputDecoration getFieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadDepartments();
    loadRoles();
  }

  Future<void> loadDepartments() async {
    try {
      departments = await apiService.fetchDepartments();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => loadingDept = false);
  }

  Future<void> loadRoles() async {
    try {
      roles = await apiService.fetchRoles();
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => loadingRole = false);
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Signup Successful!"),
            ],
          ),
          content: const Text(
            "Your account has been created successfully.",
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400, maxHeight: 700),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Signup",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  CustomTextfield(hint: "Name", controller: nameController),
                  const SizedBox(height: 15),
                  CustomTextfield(hint: "Email", controller: emailController),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    hint: "Phone Number",
                    controller: phoneController,
                  ),
                  const SizedBox(height: 15),
                  loadingDept
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          decoration: getFieldDecoration("Department"),
                          items: departments.map((dept) {
                            return DropdownMenuItem<int>(
                              value: dept.id,
                              child: Text(dept.name),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => selectedDepartmentId = value),
                        ),
                  const SizedBox(height: 15),

                  loadingRole
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<int>(
                          decoration: getFieldDecoration("Role"),
                          items: roles.map((role) {
                            return DropdownMenuItem<int>(
                              value: role.id,
                              child: Text(role.name),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => selectedRoleId = value),
                        ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    hint: "Password",
                    controller: passwordController,
                    obscure: obscure,
                    suffixIcon: obscure
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixTap: () => setState(() => obscure = !obscure),
                  ),
                  // const SizedBox(height: 15),
                  // CustomTextfield(
                  //   hint: "Confirm Password",
                  //   controller: confirmpassword,
                  //   obscure: obscure,
                  //   suffixIcon: obscure ? Icons.visibility_off : Icons.visibility,
                  // onSuffixTap: () => setState(() => obscure = !obscure),
                  // ),
                  const SizedBox(height: 20),
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

                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (selectedDepartmentId == null ||
                                  selectedRoleId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select Department and Role",
                                    ),
                                  ),
                                );
                                return;
                              }
                              setState(() => isSubmitting = true);
                              try {
                                User newUser = User(
                                  name: nameController.text,
                                  email: emailController.text,
                                  phoneNumber: phoneController.text,
                                  departmentId: selectedDepartmentId!,
                                  roleId: selectedRoleId!,
                                  authProvider: 'local',
                                );

                                final apiService = ApiService();
                                bool isSuccess = await apiService.registerUser(
                                  newUser,
                                  passwordController.text,
                                );

                                setState(() => isSubmitting = false);

                                if (isSuccess) {
                                  _showSuccessDialog();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Signup failed! Please try again.",
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                setState(() => isSubmitting = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("An error occurred: $e"),
                                  ),
                                );
                              }
                            },

                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Sign Up"),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.grey, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                      SocialIconButton(
                        icon: FontAwesomeIcons.microsoft,
                        iconColor: const Color(0xFF00A4EF),
                        onTap: () {},
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
                      const Text("Already have an acoount?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
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
      ),
    );
  }
}
