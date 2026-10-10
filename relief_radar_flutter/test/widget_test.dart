import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:relief_radar_flutter/src/screens/home_page.dart';

void main() {
  testWidgets('HomePage renders dashboard title and logout button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    expect(find.text('Relief Radar - Dashboard'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
