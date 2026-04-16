import 'package:flutter/material.dart';
import 'package:hinos/home_nova_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeNovaPage(),
      title: "Hinos",
    );
  }
}
