import 'package:flutter/material.dart';
import 'package:hinos/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fonteTamanho = 17.2;
    return MaterialApp(
      home: HomePage(),
      title: "Hinos",
      theme: ThemeData(
        textTheme: TextTheme(
          displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
          displayLarge: TextStyle(fontSize: 70.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              fontSize: 34.0, fontStyle: FontStyle.italic, color: Colors.white),
          bodyMedium: TextStyle(
              fontSize: fonteTamanho,
              color: Colors.white), // tamanho e cor do texto
        ),
      ),
    );
  }
}
