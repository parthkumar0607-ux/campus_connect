import 'package:flutter/material.dart';
import 'package:campus_connect_v2/core/theme/app_theme.dart';
import 'package:campus_connect_v2/features/splash/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusConnect',
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF090B10),
        canvasColor: const Color(0xFF090B10),
        cardColor: const Color(0xFF11151D),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF090B10),
        canvasColor: const Color(0xFF090B10),
        cardColor: const Color(0xFF11151D),
      ),
      home: const SplashScreen(),
    );
  }
}