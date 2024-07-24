import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索'),
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: const Center(
        child: Text('Search Page'),
      ),
    );
  }
}
