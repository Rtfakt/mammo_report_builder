import 'package:flutter/material.dart';

import 'ui/home_page.dart';

/// Радиус карточек Material 3 — те же скругления у кнопок, чипов и
/// сегментированных переключателей (плотность ACR, Норма / ФЖИ / ФКИ).
const _uiCornerRadius = 12.0;

final _uiShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(_uiCornerRadius),
);

void main() {
  runApp(const MammoReportBuilderApp());
}

class MammoReportBuilderApp extends StatelessWidget {
  const MammoReportBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(shape: WidgetStatePropertyAll(_uiShape));

    return MaterialApp(
      title: 'Конструктор маммографических заключений',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        cardTheme: CardThemeData(shape: _uiShape),
        filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        segmentedButtonTheme: SegmentedButtonThemeData(style: buttonStyle),
        chipTheme: ChipThemeData(shape: _uiShape),
      ),
      home: const HomePage(),
    );
  }
}
