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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF090B10),
        canvasColor: const Color(0xFF090B10),
        cardColor: const Color(0xFF11151D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      },
    );
  }
}