import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/signature_config.dart';

class FontThumbnailRow extends StatelessWidget {
  const FontThumbnailRow({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Font',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSizes.gapXs),
        SizedBox(
          height: 72.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: SignatureFont.all.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: AppSizes.hGapS),
            itemBuilder: (context, index) {
              final font = SignatureFont.all[index];
              final isSelected = index == selectedIndex;
              return _FontThumbnail(
                font: font,
                isSelected: isSelected,
                onTap: () => onTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FontThumbnail extends StatelessWidget {
  const _FontThumbnail({
    required this.font,
    required this.isSelected,
    required this.onTap,
  });

  final SignatureFont font;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80.w,
        padding: EdgeInsets.all(AppSizes.gapS),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusS)),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
            width: isSelected ? 2.w : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Aa',
                  style: TextStyle(
                    fontFamily: font.family,
                    fontSize: 20.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              font.label.split(' ').first,
              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
