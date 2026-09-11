import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';

abstract final class SignatureColors {
  static const List<Color> swatches = [
    Color(0xFF1A1A1A),
    Color(0xFF0D47A1),
    Color(0xFF1B5E20),
    Color(0xFFB71C1C),
    Color(0xFF4A148C),
    Color(0xFFE65100),
    Color(0xFF006064),
    Color(0xFF880E4F),
  ];

  static String toHex(Color c) =>
      '${(c.a * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(c.r * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(c.g * 255).round().toRadixString(16).padLeft(2, '0')}'
      '${(c.b * 255).round().toRadixString(16).padLeft(2, '0')}';
}

class ColorSwatchRow extends StatelessWidget {
  const ColorSwatchRow({
    super.key,
    required this.selectedHex,
    required this.onSelect,
  });

  final String selectedHex;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: AppSizes.gapXs),
        Wrap(
          spacing: AppSizes.hGapS,
          runSpacing: AppSizes.gapS,
          children: SignatureColors.swatches.map((color) {
            final hex = SignatureColors.toHex(color);
            final isSelected = hex == selectedHex;
            return _SwatchDot(
              color: color,
              isSelected: isSelected,
              onTap: () => onSelect(hex),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SwatchDot extends StatelessWidget {
  const _SwatchDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.r,
        height: 36.r,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
            width: isSelected ? 2.5.w : 1,
          ),
        ),
      ),
    );
  }
}
