import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mammo_report_builder/main.dart';

void main() {
  testWidgets('приложение запускается и показывает обе вкладки', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MammoReportBuilderApp());
    await tester.pumpAndSettle();

    expect(find.text('Конструктор'), findsOneWidget);
    expect(find.text('История'), findsOneWidget);
    expect(find.text('Справа'), findsOneWidget);
    expect(find.text('Слева'), findsOneWidget);
  });

  testWidgets('крестик на карточке отмечает железу как удалённую', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MammoReportBuilderApp());
    await tester.pumpAndSettle();

    final closeButton = find.byTooltip('Молочная железа удалена').first;
    await tester.ensureVisible(closeButton);
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(find.text('Молочная железа удалена'), findsOneWidget);
    expect(
      find.textContaining('Правая молочная железа удалена.'),
      findsOneWidget,
    );
    expect(find.textContaining('BIRADS 1 слева.'), findsOneWidget);
  });
}
