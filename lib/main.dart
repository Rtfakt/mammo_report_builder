import 'package:flutter/material.dart';

import 'ui/home_page.dart';

void main() {
  runApp(const MammoReportBuilderApp());
}

class MammoReportBuilderApp extends StatelessWidget {
  const MammoReportBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Конструктор маммографических заключений',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
