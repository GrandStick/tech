import 'package:flutter/material.dart';
import 'views/menu_page.dart';
import 'views/techniques_list.dart';
import 'views/account_page.dart';
import 'views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krav Maga Techniques',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MenuPage(),
    );
  }
}