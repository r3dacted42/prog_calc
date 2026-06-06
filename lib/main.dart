import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen/calculator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final fontFamily = GoogleFonts.sometypeMono().fontFamily;

    return MaterialApp(
      title: 'PROG_CALC',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        fontFamily: fontFamily,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        brightness: Brightness.dark,
        fontFamily: fontFamily,
      ),
      home: const CalculatorScreen(),
    );
  }
}
