import 'package:flutter/material.dart';
import 'views/techniques_list.dart';

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
      home: TechniquesList(),
    );
  }
}