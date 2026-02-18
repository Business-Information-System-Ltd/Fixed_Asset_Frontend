// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
// import 'package:fixed_asset_frontend/screens/dashboard.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'dart:convert';
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// bool _isLoading = false;

// class AuthService {
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;
//   AuthService._internal();

//   static final Config config = Config(
//     tenant: '6424c4c1-87db-4bee-b669-52a240a51619',
//     clientId: 'c40df40a-9e4b-4280-89ea-b77effba21b3',
//     scope: 'openid profile email User.Read',
//     redirectUri: Uri.base.origin,
//     responseType: 'code',
//     navigatorKey: navigatorKey,
//     loader: const Center(child: CircularProgressIndicator()),
//   );

//   final AadOAuth oauth = AadOAuth(config);

//   Future<void> loginWithMicrosoft(BuildContext context) async {
//   try {

//     await oauth.login();

//     if (context.mounted) {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );
//     }

//     String? idToken = await oauth.getIdToken();

//     if (idToken != null) {
//       await sendTokenToBackend(idToken, context);
//     } else {
//       if (context.mounted) Navigator.pop(context);
//     }
//   } catch (e) {
//     debugPrint("Login Error: $e");
//     if (context.mounted) {

//       Navigator.of(context, rootNavigator: true).pop();
//     }
//   }
// }

//   Future<void> sendTokenToBackend(String token, BuildContext context) async {
//     final response = await http.post(
//       Uri.parse('http://127.0.0.1:8000/api/microsoft-login/'),
//       body: {'token': token},
//     );
//     if (context.mounted) Navigator.pop(context);

//     if (response.statusCode == 200) {
//       if (context.mounted) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const MainScreen()),
//           (route) => false,
//         );
//       }
//       debugPrint("Backend Response: ${response.body}");
//     } else {
//       debugPrint("Backend Error: ${response.body}");
//     }
//   }
// }

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AuthService {
  static final Config config = Config(
    tenant: 'YOUR_TENANT_ID',
    clientId: 'YOUR_CLIENT_ID',
    scope: 'openid profile email User.Read',
    redirectUri: Uri.base.origin,
    navigatorKey: navigatorKey,
  );

  final AadOAuth oauth = AadOAuth(config);

  Future<void> login() async {
    await oauth.login();
    final token = await oauth.getIdToken();
    debugPrint("ID Token: $token");
  }
}
