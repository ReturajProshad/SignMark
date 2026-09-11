import 'package:flutter/material.dart';

/// Centralized color palette for SignMark. No ad-hoc hex values should appear inline in widgets — always reference a named color from here
abstract final class AppColors {
  /// Primary brand red — buttons, focus borders, selection rings, selected
  /// tab underline. One consistent red is used across both screens.
  static const Color primaryRed = Color(0xFFE5322D);

  /// A translucent red used for subtle selected backgrounds / ripples.
  static const Color primaryRedTint = Color(0x1AE5322D); // ~10% red

  /// App scaffold background.
  static const Color background = Color(0xFFFAFAFA);

  /// Base surface (app bar, sheets).
  static const Color surface = Color(0xFFFFFFFF);

  /// Card / grouped-input surface.
  static const Color surfaceVariant = Color(0xFFF4F5F7);

  /// Default (unfocused) border.
  static const Color border = Color(0xFFE0E0E0);

  /// Primary text.
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Secondary / hint text.
  static const Color textSecondary = Color(0xFF6B7280);

  /// Disabled controls & stub labels.
  static const Color disabled = Color(0xFFBDBDBD);

  /// Text/icon color drawn on top of [primaryRed].
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Accent used by success dialogs (saved-file confirmation).
  static const Color success = Color(0xFF2E7D32);

  /// Accent used by error dialogs (read/write failures).
  static const Color error = Color(0xFFC62828);
}
