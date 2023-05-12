import 'package:flutter/material.dart';
import 'views/techniques_list.dart';
import 'views/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krav Maga Techniques',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[800],
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
        ),
      ),
      home: LoginPage(),
    );
  }
}