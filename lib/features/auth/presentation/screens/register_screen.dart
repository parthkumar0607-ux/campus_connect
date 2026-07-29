import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:campus_connect_v2/features/auth/data/repositories/auth_repository.dart';
import 'package:campus_connect_v2/shared/widgets/glass_card.dart';
import 'package:campus_connect_v2/shared/widgets/gradient_scaffold.dart';
import 'package:campus_connect_v2/shared/widgets/primary_button.dart';
import 'package:campus_connect_v2/shared/widgets/primary_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthRepository repository = AuthRepository();

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await repository.register(
        name: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully 🎉")),
      );

      Navigator.pop(context);
    } on DioException catch (e) {
      String message = "Registration failed";

      if (e.response != null && e.response!.data is Map) {
        final detail = e.response!.data["detail"];

        if (detail is String) {
          message = detail;
        } else if (detail is List && detail.isNotEmpty) {
          final first = detail.first;

          if (first is Map && first["msg"] != null) {
            message = first["msg"].toString();
          } else {
            message = detail.toString();
          }
        }
      } else {
        message = e.message ?? "Network Error";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 25),

              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
                  ),
                  boxShadow: const [
                    BoxShadow(color: Color(0x556366F1), blurRadius: 30),
                  ],
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Create Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Join your college community",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 35),

              GlassCard(
                child: Column(
                  children: [
                    PrimaryTextField(
                      controller: fullNameController,
                      hintText: "Full Name",
                      prefixIcon: Icons.person_outline,
                    ),

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: emailController,
                      hintText: "College Email",
                      prefixIcon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: passwordController,
                      hintText: "Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        color: Colors.white70,
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

                    const SizedBox(height: 18),

                    PrimaryTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscureConfirmPassword,
                      suffixIcon: IconButton(
                        color: Colors.white70,
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    PrimaryButton(
                      text: "Create Account",
                      isLoading: isLoading,
                      onPressed: register,
                    ),

                    const SizedBox(height: 18),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
