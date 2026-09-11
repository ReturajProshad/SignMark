import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/signature_config.dart';

class LivePreviewCard extends StatelessWidget {
  const LivePreviewCard({
    super.key,
    required this.name,
    required this.font,
    required this.fontSizePt,
    required this.isBold,
    required this.color,
  });

  final String name;
  final SignatureFont font;
  final double fontSizePt;
  final bool isBold;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final displayText = name.isEmpty ? 'Preview' : name;
    final displayFontSize = fontSizePt.sp;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Preview', style: AppTextStyles.label),
          SizedBox(height: AppSizes.gapS),
          SizedBox(
            width: double.infinity,
            height: 80.h,
            child: Center(
              child: Text(
                displayText,
                style: TextStyle(
                  fontFamily: font.family,
                  fontSize: displayFontSize.clamp(20.sp, 80.sp),
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
