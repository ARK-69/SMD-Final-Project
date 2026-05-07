import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
    super.key,
    this.icon = Icons.search,
  });

  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 350),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 128,
                width: 128,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.purple, size: 58),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: 160,
                child: PrimaryButton(label: buttonLabel, onPressed: onPressed),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
