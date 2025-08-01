import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 100),
            SizedBox(height: 20),
            Text('Search Page', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('This screen is working!'),
          ],
        ),
      ),
    );
  }
}
