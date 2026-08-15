import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF22304F), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(text, style: const TextStyle(color: Color(0xFF8E9BB5), fontSize: 13)),
        ),
        const Expanded(child: Divider(color: Color(0xFF22304F), thickness: 1)),
      ],
    );
  }
}