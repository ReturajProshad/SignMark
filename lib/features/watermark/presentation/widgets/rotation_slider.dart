import 'package:flutter/material.dart';

import '../../../../core/constants/pdf_defaults.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class RotationSlider extends StatelessWidget {
  const RotationSlider({
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
            Text('Rotation', style: AppTextStyles.label),
            Text(
              '${value.toInt()}°',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        Slider(
          value: value,
          min: PdfDefaults.watermarkMinRotationDegrees,
          max: PdfDefaults.watermarkMaxRotationDegrees,
          divisions: PdfDefaults.watermarkMaxRotationDegrees.toInt(),
          activeColor: AppColors.primaryRed,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
