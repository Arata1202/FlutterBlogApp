import 'package:flutter/material.dart';

class Notice extends StatelessWidget {
  const Notice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('筆者について'),
      ),
      body: const Center(
        child: Text('筆者についての情報がここに表示されます。'),
      ),
    );
  }
}
