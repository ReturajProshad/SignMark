import 'package:flutter/material.dart';

import '../../../../core/constants/pdf_defaults.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TransparencySlider extends StatelessWidget {
  const TransparencySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

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
            Text('Transparency', style: AppTextStyles.label),
            Text(
              '${value.toInt()}%',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        Slider(
          value: value,
          min: PdfDefaults.watermarkMinOpacityPercent.toDouble(),
          max: PdfDefaults.watermarkMaxOpacityPercent.toDouble(),
          divisions: PdfDefaults.watermarkMaxOpacityPercent,
          activeColor: AppColors.primaryRed,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
