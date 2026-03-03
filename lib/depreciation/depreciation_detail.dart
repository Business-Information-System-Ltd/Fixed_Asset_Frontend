import 'package:flutter/material.dart';

class DepreciationDetail extends StatefulWidget {
  const DepreciationDetail({super.key});

  @override
  State<DepreciationDetail> createState() => _DepreciationDetailState();
}

class _DepreciationDetailState extends State<DepreciationDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Depreciation Detail')),
      body: Container(),
    );
  }
}
