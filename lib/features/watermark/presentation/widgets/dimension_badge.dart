import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class DimensionBadge extends StatelessWidget {
  const DimensionBadge({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.hGapS,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryRedTint,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusS)),
        border: Border.all(color: AppColors.primaryRed, width: 1.w),
      ),
      child: Text(
        '${width.toInt()} × ${height.toInt()} pt',
        style: AppTextStyles.caption.copyWith(color: AppColors.primaryRed),
      ),
    );
  }
}
