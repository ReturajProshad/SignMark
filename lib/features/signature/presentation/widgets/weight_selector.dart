import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';

class WeightSelector extends StatelessWidget {
  const WeightSelector({
    super.key,
    required this.isBold,
    required this.onToggle,
  });

  final bool isBold;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSizes.gapXs),
        Row(
          children: [
            _WeightBox(
              label: 'Aa',
              fontWeight: FontWeight.w400,
              isSelected: !isBold,
              onTap: () {
                if (isBold) onToggle();
              },
            ),
            SizedBox(width: AppSizes.hGapM),
            _WeightBox(
              label: 'Aa',
              fontWeight: FontWeight.w700,
              isSelected: isBold,
              onTap: () {
                if (!isBold) onToggle();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _WeightBox extends StatelessWidget {
  const _WeightBox({
    required this.label,
    required this.fontWeight,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final FontWeight fontWeight;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusS)),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
            width: isSelected ? 2.w : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: fontWeight,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
