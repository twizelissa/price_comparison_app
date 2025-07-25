import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatelessWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Verification'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone_android, size: 100),
            SizedBox(height: 20),
            Text('Phone Verification', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text('This screen is working!'),
          ],
        ),
      ),
    );
  }
}
