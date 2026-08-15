import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:campus_connect_v2/core/network/api_client.dart';
import 'package:campus_connect_v2/core/services/storage_service.dart';
import 'package:campus_connect_v2/features/auth/presentation/screens/login_screen.dart';
import 'package:campus_connect_v2/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:campus_connect_v2/shared/widgets/gradient_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    checkLogin();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    final token = await StorageService.getToken();
    if (!mounted) return;
    if (token == null || token.isEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    try {
      await ApiClient.dio.get('/users/me');
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
    } on DioException {
      await StorageService.logout();
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: FadeTransition(
        opacity: controller,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.84, end: 1),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              builder: (context, value, child) => Transform.scale(scale: value, child: child),
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(34),
                  gradient: const LinearGradient(colors: [Color(0xFF5865F2), Color(0xFF8B5CF6)]),
                  boxShadow: const [BoxShadow(color: Color(0x665865F2), blurRadius: 34)],
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 58),
              ),
            ),
            const SizedBox(height: 28),
            const Text('CampusConnect', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Connect • Collaborate • Grow', style: TextStyle(color: Color(0xFF8E9BB5), fontSize: 15)),
            const SizedBox(height: 36),
            const SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}