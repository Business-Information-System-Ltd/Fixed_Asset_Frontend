import 'package:fixed_asset_frontend/depreciation/asset_depreciaiton_policy.dart';
import 'package:fixed_asset_frontend/depreciation/depreciation_convention.dart';
import 'package:fixed_asset_frontend/leaseScreen/leaseEntry.dart';
import 'package:fixed_asset_frontend/screens/fix_asset_form.dart';
import 'package:fixed_asset_frontend/screens/fixed_asset_list.dart';
import 'package:fixed_asset_frontend/screens/general_ledger.dart';
import 'package:fixed_asset_frontend/screens/wip.dart';
import 'package:fixed_asset_frontend/screens/wip_item.dart';
import 'package:fixed_asset_frontend/screens/wip_list.dart';
import 'package:fixed_asset_frontend/system_default/asset_book.dart';
import 'package:fixed_asset_frontend/system_default/settings.dart';
import 'package:fixed_asset_frontend/userInformation/login.dart';
import 'package:fixed_asset_frontend/widgets/googleAuthService.dart';
import 'package:flutter/material.dart';
import 'package:fixed_asset_frontend/widgets/microsoftAuthService.dart'
    as microsoft;

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: microsoft.navigatorKey,
      home: LoginScreen(),
    ),
  );
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
