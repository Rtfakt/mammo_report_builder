import 'package:flutter_test/flutter_test.dart';

import 'package:mammo_report_builder/main.dart';

void main() {
  testWidgets('приложение запускается и показывает обе вкладки', (WidgetTester tester) async {
    await tester.pumpWidget(const MammoReportBuilderApp());
    await tester.pumpAndSettle();

    expect(find.text('Конструктор'), findsOneWidget);
    expect(find.text('История'), findsOneWidget);
    expect(find.text('Справа'), findsOneWidget);
    expect(find.text('Слева'), findsOneWidget);
  });

  testWidgets('добавление находки "Норма" не ломает UI', (WidgetTester tester) async {
    await tester.pumpWidget(const MammoReportBuilderApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Добавить').first);
    await tester.pumpAndSettle();

    expect(find.text('Норма'), findsWidgets);
  });
}
