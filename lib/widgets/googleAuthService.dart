import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:fixed_asset_frontend/screens/dashboard.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "393055156725-a20q2m7hf2v18qj8584cambq03nom3bj.apps.googleusercontent.com",
    scopes: ['email'],
  );

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 15),
              // Text("Please wait...", style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      );
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final String? tokenToSend = googleAuth.idToken;

        if (tokenToSend != null) {
          print("Token ရပါပြီ၊ Backend ကို ပို့နေသည်...");
          await sendTokenToDjango(tokenToSend, context);
        } else {
          print("Error: Token လုံးဝ မရရှိပါ");
          if (context.mounted) Navigator.pop(context);
        }
      }
    } catch (error) {
      if (context.mounted) Navigator.pop(context);
      print("Google Sign-In Error: $error");
    }
  }

  Future<void> sendTokenToDjango(String token, BuildContext context) async {
    // final String apiUrl = "http://127.0.0.1:8000/api/google-login/";
    final String apiUrl =
        "https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api/google-login/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'token': token},
      );

      if (context.mounted) Navigator.pop(context);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final loginResult = LoginResponse.fromJson(responseData);
        var data = json.decode(response.body);
        print("Backend Login အောင်မြင်သည်: ${data['email']}");

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(userData: loginResult),
            ),
            (route) => false,
          );
        }
      } else {
        print("Backend Error: ${response.body}");
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      print("Network Error: $e");
    }
  }
}
