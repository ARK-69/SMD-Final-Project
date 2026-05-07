import 'package:flutter/material.dart';

import 'empty_state.dart';

class RetryView extends StatelessWidget {
  const RetryView({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'Something went wrong',
      message: 'Please check your connection and try loading places again.',
      buttonLabel: 'Retry',
      icon: Icons.wifi_off_rounded,
      onPressed: onRetry,
    );
  }
}
