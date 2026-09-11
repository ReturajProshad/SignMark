import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/watermark_config.dart';

class AnchorGrid extends StatelessWidget {
  const AnchorGrid({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  final AnchorPosition selected;
  final ValueChanged<AnchorPosition> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Position', style: AppTextStyles.label),
        SizedBox(height: AppSizes.gapXs),
        SizedBox(
          width: 120.w,
          height: 120.h,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 4.w,
            crossAxisSpacing: 4.w,
            physics: const NeverScrollableScrollPhysics(),
            children: AnchorPosition.values.map((anchor) {
              final isSelected = anchor == selected;
              return GestureDetector(
                onTap: () => onSelect(anchor),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryRedTint
                        : AppColors.surface,
                    borderRadius: BorderRadius.all(
                      Radius.circular(AppSizes.radiusS),
                    ),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.border,
                      width: isSelected ? 2.w : 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryRed
                            : AppColors.disabled,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
