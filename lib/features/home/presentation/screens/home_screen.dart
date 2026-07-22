import 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CampusConnect"),
      ),
      body: Center(
        child: Text(
          "Welcome to CampusConnect 🚀",
          style: AppTextStyles.heading2,
        ),
      ),
    );
  }
}