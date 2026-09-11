import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable, responsive dimensions expressed in screenutil units.
abstract final class AppSizes {
  // Vertical spacing.
  static double get gapXs => 4.h;
  static double get gapS => 8.h;
  static double get gapM => 16.h;
  static double get gapL => 24.h;
  static double get gapXl => 32.h;

  // Horizontal spacing.
  static double get hGapS => 8.w;
  static double get hGapM => 16.w;

  // Padding.
  static double get screenPadding => 16.w;
  static double get cardPadding => 16.w;

  // Corner radii.
  static double get radiusS => 8.r;
  static double get radiusM => 12.r;
  static double get radiusL => 16.r;

  // Controls.
  static double get buttonHeight => 52.h;
  static double get iconS => 18.r;
  static double get iconM => 24.r;
  static double get iconL => 48.r;
}
