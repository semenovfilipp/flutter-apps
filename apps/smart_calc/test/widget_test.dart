import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_calc/main.dart';

void main() {
  testWidgets('SmartCalc app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartCalcApp());

    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Scientific'), findsOneWidget);
    expect(find.text('Currency'), findsOneWidget);
    expect(find.text('Units'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
