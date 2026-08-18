import 'package:flutter/material.dart';
import 'package:campus_connect_v2/core/theme/app_colors.dart';

class SkillChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool secondary;

  const SkillChip({super.key, required this.label, this.icon, this.secondary = false});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).chipTheme.labelStyle ?? const TextStyle(color: AppColors.textPrimary);

    final borderColor = secondary ? AppColors.accentCyan.withValues(alpha: 0.12) : AppColors.primary.withValues(alpha: 0.16);
    final textColor = secondary ? AppColors.accentCyan : Colors.white;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 32),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: textStyle.copyWith(color: textColor, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
