import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Full-width red action button shared by both feature screens
/// ("Done" / "Apply Watermark").
///
/// Disables itself and shows a spinner while [isLoading] is true, or when
/// [onPressed] is null (see `master_plan/04_design_system.md`).
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        child: isLoading
            ? SizedBox(
                width: AppSizes.iconM,
                height: AppSizes.iconM,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.onPrimary,
                  ),
                ),
              )
            : Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
