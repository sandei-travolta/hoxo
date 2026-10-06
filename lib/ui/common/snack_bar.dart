import 'dart:math' as math;

import 'package:flutter/material.dart';

enum _SnackType { success, error, message }

/// Floating, compact snack bars with a consistent look.
///
/// ```dart
/// AppSnackBar.success(context, 'Changes saved successfully.');
/// AppSnackBar.error(context, 'Could not save the client.');
/// AppSnackBar.message(context, 'Mobile copied');
/// ```
class AppSnackBar {
  const AppSnackBar._();

  static const Color _successColor = Color(0xFF2E7D32);

  /// Green confirmation, e.g. after saving.
  static void success(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) =>
      _show(context, message, _SnackType.success, action, duration);

  /// Red failure message. Stays a little longer by default.
  static void error(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) =>
      _show(context, message, _SnackType.error, action, duration);

  /// Neutral message for general information.
  static void message(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) =>
      _show(context, message, _SnackType.message, action, duration);

  static void _show(
    BuildContext context,
    String message,
    _SnackType type,
    SnackBarAction? action,
    Duration duration,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    final (bg, fg, icon) = switch (type) {
      _SnackType.success => (
          _successColor,
          Colors.white,
          Icons.check_circle_outline_rounded,
        ),
      _SnackType.error => (
          scheme.error,
          scheme.onError,
          Icons.error_outline_rounded,
        ),
      _SnackType.message => (
          scheme.inverseSurface,
          scheme.onInverseSurface,
          Icons.info_outline_rounded,
        ),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // Compact on desktop, but never wider than the screen on phones.
          width: math.min(400.0, screenWidth - 32),
          backgroundColor: bg,
          duration: duration,
          action: action,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Row(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: TextStyle(color: fg)),
              ),
            ],
          ),
        ),
      );
  }
}