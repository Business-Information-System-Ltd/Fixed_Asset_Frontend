import 'package:fixed_asset_frontend/system_default/system_default_component.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SystemDefaultPage(),
    ),
  );
}

class SystemDefaultPage extends StatelessWidget {
  const SystemDefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SYSTEM DEFAULT POLICY"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(child: DepreciationMainPanel()),
      ),
    );
  }
}
