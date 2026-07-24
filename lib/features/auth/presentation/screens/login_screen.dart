import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter email and password"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await repository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await StorageService.saveToken(
        response.accessToken,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
      );
    } on DioException catch (e) {
      String message = "Login failed";

      if (e.response != null &&
          e.response!.data is Map &&
          e.response!.data["detail"] != null) {
        message = e.response!.data["detail"];
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              const Icon(
                Icons.school_rounded,
                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(
                "CampusConnect",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Welcome Back!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              PrimaryTextField(
                controller: emailController,
                hintText: "College Email",
                prefixIcon: Icons.email_outlined,
              ),

              const SizedBox(height: 20),

              PrimaryTextField(
                controller: passwordController,
                hintText: "Password",
                prefixIcon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 30),

              PrimaryButton(
                text: "Login",
                isLoading: isLoading,
                onPressed: login,
              ),

              const SizedBox(height: 25),

              const DividerWithText(
                text: "OR",
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}