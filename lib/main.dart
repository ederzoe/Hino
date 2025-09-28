import 'package:flutter/material.dart';
import 'package:hinos/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final double fontSizeSmall = 24.0;
  final double fontSizeMedium = 42.0;
  final double fontSizeLarge = 70.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: "Hinos",
    );
  }
}
