import 'package:fixed_asset_frontend/leaseScreen/leaseList.dart';
import 'package:fixed_asset_frontend/screens/fix_asset_form.dart';
import 'package:fixed_asset_frontend/screens/fixed_asset_list.dart';
import 'package:fixed_asset_frontend/screens/general_ledger.dart';
import 'package:fixed_asset_frontend/screens/wip.dart';
import 'package:fixed_asset_frontend/screens/wip_item.dart';
import 'package:fixed_asset_frontend/screens/wip_list.dart';
import 'package:fixed_asset_frontend/widgets/googleAuthService.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Leaselist()));
}

class LoginScreen extends StatelessWidget {
  final GoogleAuthService _authService = GoogleAuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _authService.signInWithGoogle(context),
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WIPListScreen()),
                ),
                child: Text('Open Wip List'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => WipItemForm())),
                child: Text('Open WipItem From'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => WipForm())),
                child: Text('Open WIP From'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GeneralLedger()),
                ),
                child: Text('Open General Ledger Form'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => FixAssetForm())),
                child: Text('Open Fixed Asset Form'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FixedAssetListScreen(),
                  ),
                ),
                child: Text('Open Fixed Asset List'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
