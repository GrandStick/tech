import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bienvenue dans l\'application Krav Maga Techniques !',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}