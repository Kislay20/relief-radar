import 'package:flutter/material.dart';

import 'client.dart';
import 'src/screens/home_page.dart';
import 'src/screens/login_page.dart';
import 'src/services/notification_service.dart';
import 'src/services/offline_sync_service.dart';

import 'src/theme/app_theme.dart';

/// Global messenger key for displaying high-priority alerts and sync confirmations
/// across the entire application lifecycle without BuildContext dependency issues.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OfflineSyncService.initialize();
  await NotificationService.initialize();
  await initializeClient();
  OfflineSyncService.registerClient(client);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'Relief Radar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      // Automatically bypasses login screen if user session persists across restarts
      home: ListenableBuilder(
        listenable: sessionManager,
        builder: (context, _) {
          return sessionManager.isSignedIn
              ? const HomePage()
              : const LoginPage();
        },
      ),
    );
  }
}
