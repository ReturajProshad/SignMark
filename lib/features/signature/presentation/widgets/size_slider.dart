import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/pdf_defaults.dart';
import '../../../../core/theme/app_colors.dart';

class SizeSlider extends StatelessWidget {
  const SizeSlider({super.key, required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Size',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            Text(
              '${value.round()} pt',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
            ),
          ],
        ),
        SizedBox(height: AppSizes.gapXs),
        Slider(
          value: value,
          min: PdfDefaults.signatureMinFontSize,
          max: PdfDefaults.signatureMaxFontSize,
          divisions:
              (PdfDefaults.signatureMaxFontSize -
                      PdfDefaults.signatureMinFontSize)
                  .round(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
