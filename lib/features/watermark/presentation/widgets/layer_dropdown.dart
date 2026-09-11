import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/watermark_config.dart';

class LayerDropdown extends StatelessWidget {
  const LayerDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WatermarkLayer selected;
  final ValueChanged<WatermarkLayer> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Layer', style: AppTextStyles.label),
        SizedBox(height: 4.h),
        DropdownButtonFormField<WatermarkLayer>(
          initialValue: selected,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.gapS,
              vertical: 4.h,
            ),
          ),
          items: const [
            DropdownMenuItem(
              value: WatermarkLayer.over,
              child: Text('Over PDF content'),
            ),
            DropdownMenuItem(
              value: WatermarkLayer.under,
              child: Text('Under PDF content'),
            ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}
