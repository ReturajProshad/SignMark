import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_sizes.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Builds the app's light theme from the design system.

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryRed,
      primary: AppColors.primaryRed,
      onPrimary: AppColors.onPrimary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.subtitle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.hGapM,
          vertical: AppSizes.gapS,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
          borderSide: BorderSide(color: AppColors.primaryRed, width: 1.5.w),
        ),
        hintStyle: AppTextStyles.label,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primaryRed,
        thumbColor: AppColors.primaryRed,
        inactiveTrackColor: AppColors.border,
        overlayColor: AppColors.primaryRedTint,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.disabled,
          disabledForegroundColor: AppColors.onPrimary,
          elevation: 0,
          minimumSize: Size(double.infinity, AppSizes.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border),
    );
  }
}
