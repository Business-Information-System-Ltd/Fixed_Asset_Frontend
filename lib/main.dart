import 'package:fixed_asset_frontend/screens/fix_asset_form.dart';
import 'package:fixed_asset_frontend/screens/general_ledger.dart';
import 'package:fixed_asset_frontend/screens/wip.dart';
import 'package:fixed_asset_frontend/screens/wip_item.dart';
import 'package:fixed_asset_frontend/screens/wip_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
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
            ],
          ),
        ),
      ),
    );
  }
}
