import 'package:fixed_asset_frontend/api/data.dart';
import 'package:fixed_asset_frontend/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "393055156725-a20q2m7hf2v18qj8584cambq03nom3bj.apps.googleusercontent.com",
    scopes: ['email', 'profile'],
  );

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) {
        if (context.mounted) Navigator.pop(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;


  final String? tokenToSend = googleAuth.idToken ?? googleAuth.accessToken;

if (tokenToSend != null) {
  print("Debug - Token ရရှိပါပြီ၊ Backend သို့ ပို့နေသည်...");
  await sendTokenToDjango(tokenToSend, context);
} else {
  print("Error: Token  မရပါ ❌");
}

    } catch (error) {
      if (context.mounted) Navigator.pop(context);
      debugPrint("Google Sign-In Error: $error");
    }
  }

  Future<void> sendTokenToDjango(
      String accessToken, BuildContext context) async {

        // const String apiUrl =
        // "http://127.0.0.1:8000/api/google-login/";


    const String apiUrl =
        "https://fixedassetbackend-dchggqcdd7gefsb5.canadacentral-01.azurewebsites.net/api/google-login/";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "access_token": accessToken,
        }),
      );

      if (context.mounted) Navigator.pop(context);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        final loginResult = LoginResponse.fromJson(responseData);

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainScreen(userData: loginResult),
            ),
            (route) => false,
          );
        }
      } else {
        debugPrint("Backend Error: ${response.body}");
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      debugPrint("Network Error: $e");
    }
  }
}
