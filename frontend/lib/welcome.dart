import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0), // Set your desired height here
        child:
            AppBar(title: Text('Welcome Back!'), backgroundColor: Colors.green),
      ),
      body: Center(
        child: Text(
          'Hello, Flutter',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
