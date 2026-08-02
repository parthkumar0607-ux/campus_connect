import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import 'package:campus_connect_v2/shared/widgets/gradient_scaffold.dart';
import 'package:campus_connect_v2/core/services/storage_service.dart';
import 'package:campus_connect_v2/features/auth/data/repositories/auth_repository.dart';
import 'package:campus_connect_v2/features/auth/presentation/screens/register_screen.dart';
import 'package:campus_connect_v2/features/navigation/presentation/screens/main_navigation_screen.dart';
import 'package:campus_connect_v2/shared/widgets/divider_with_text.dart';
import 'package:campus_connect_v2/shared/widgets/primary_button.dart';
import 'package:campus_connect_v2/shared/widgets/primary_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository repository = AuthRepository();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your email and password')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await repository.login(email: emailController.text.trim(), password: passwordController.text);
      await StorageService.saveToken(response.accessToken);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigationScreen()));
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response!.data['detail'] != null
          ? e.response!.data['detail'].toString()
          : 'Login failed';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Column(
            children: [
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(colors: [Color(0xFF5865F2), Color(0xFF8B5CF6)]),
                  boxShadow: const [BoxShadow(color: Color(0x665865F2), blurRadius: 32)],
                ),
                child: const Icon(Icons.school_rounded, color: Colors.white, size: 46),
              ),
              const SizedBox(height: 20),
              const Text('CampusConnect', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Discord vibes • Instagram polish', style: TextStyle(color: Color(0xFF8E9BB5), fontSize: 15)),
              const SizedBox(height: 28),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Welcome back', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text('Sign in and jump back into your campus circle.', style: TextStyle(color: Color(0xFF8E9BB5))),
                    const SizedBox(height: 24),
                    PrimaryTextField(controller: emailController, hintText: 'College Email', prefixIcon: Icons.email_outlined),
                    const SizedBox(height: 14),
                    PrimaryTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        color: const Color(0xFF8E9BB5),
                        icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 22),
                    PrimaryButton(text: 'Continue', isLoading: isLoading, onPressed: login),
                    const SizedBox(height: 18),
                    const DividerWithText(text: 'OR'),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
                      child: const Text('Create new account', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
