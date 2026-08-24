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
      home: const HomeNovaPage(),
      title: "Hinos",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF088DD4),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        cardTheme: const CardThemeData(color: Colors.white),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF58B8EA),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF111417),
        cardTheme: const CardThemeData(color: Color(0xFF1B2025)),
        useMaterial3: true,
      ),
    );
  }
}
