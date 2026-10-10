import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:relief_radar_client/relief_radar_client.dart';
import 'package:relief_radar_flutter/client.dart';
import 'package:relief_radar_flutter/src/screens/home_page.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

void main() {
  setUp(() {
    client = Client('http://127.0.0.1:8080/')
      ..authKeyProvider = FlutterAuthenticationKeyManager();
    authCaller = client.modules.auth;
    sessionManager = SessionManager(caller: authCaller);
  });

  testWidgets('HomePage renders dashboard title and logout button', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    expect(find.text('RELIEF RADAR'), findsOneWidget);
    expect(find.byTooltip('Logout'), findsOneWidget);
  });
}
