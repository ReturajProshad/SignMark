import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PlacementPreview extends StatelessWidget {
  const PlacementPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Placement', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
        SizedBox(height: AppSizes.gapXs),
        Container(
          width: double.infinity,
          height: 160.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [

              Center(
                child: Container(
                  width: 100.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusS)),
                  ),
                ),
              ),
              Center(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.gapM),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.hGapS,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRedTint,
                        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusS)),
                        border: Border.all(color: AppColors.primaryRed, width: 1.5.w),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.place, size: AppSizes.iconS, color: AppColors.primaryRed),
                          SizedBox(width: 4.w),
                          Text(
                            'Bottom-center',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Fixed: bottom-center of page 1',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
