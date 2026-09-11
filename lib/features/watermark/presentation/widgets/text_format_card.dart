import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../signature/domain/entities/signature_config.dart';
import '../../../signature/presentation/widgets/color_swatch_row.dart';

class TextFormatCard extends StatelessWidget {
  const TextFormatCard({
    super.key,
    required this.text,
    required this.onTextChanged,
    required this.fontIndex,
    required this.onFontChanged,
    required this.fontSizePt,
    required this.onFontSizeChanged,
    required this.style,
    required this.onStyleChanged,
    required this.colorHex,
    required this.onColorChanged,
  });

  final String text;
  final ValueChanged<String> onTextChanged;
  final int fontIndex;
  final ValueChanged<int> onFontChanged;
  final double fontSizePt;
  final ValueChanged<double> onFontSizeChanged;
  final String style;
  final ValueChanged<String> onStyleChanged;
  final String colorHex;
  final ValueChanged<String> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Text Format', style: AppTextStyles.subtitle),
          SizedBox(height: AppSizes.gapS),
          TextField(
            decoration: InputDecoration(
              hintText: 'Watermark',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.gapS,
                vertical: AppSizes.gapXs,
              ),
            ),
            controller: TextEditingController(text: text),
            onChanged: onTextChanged,
          ),
          SizedBox(height: AppSizes.gapS),
          _buildFontDropdown(),
          SizedBox(height: AppSizes.gapS),
          _buildSizeInput(),
          SizedBox(height: AppSizes.gapS),
          _buildStyleDropdown(),
          SizedBox(height: AppSizes.gapS),
          _buildColorPicker(context),
        ],
      ),
    );
  }

  Widget _buildFontDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Font', style: AppTextStyles.label),
        SizedBox(height: 4.h),
        DropdownButtonFormField<int>(
          initialValue: fontIndex,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.gapS,
              vertical: 4.h,
            ),
          ),
          items: SignatureFont.all.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(
                entry.value.label,
                style: TextStyle(fontFamily: entry.value.family),
              ),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) onFontChanged(v);
          },
        ),
      ],
    );
  }

  Widget _buildSizeInput() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Size (pt)', style: AppTextStyles.label),
              SizedBox(height: 4.h),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.gapS,
                    vertical: 4.h,
                  ),
                ),
                controller: TextEditingController(text: fontSizePt.toInt().toString()),
                onChanged: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null && parsed > 0) {
                    onFontSizeChanged(parsed);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStyleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Style', style: AppTextStyles.label),
        SizedBox(height: 4.h),
        DropdownButtonFormField<String>(
          initialValue: style,
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
            DropdownMenuItem(value: 'regular', child: Text('Regular')),
            DropdownMenuItem(value: 'italic', child: Text('Italic')),
            DropdownMenuItem(value: 'bold', child: Text('Bold')),
            DropdownMenuItem(value: 'boldItalic', child: Text('Bold Italic')),
          ],
          onChanged: (v) {
            if (v != null) onStyleChanged(v);
          },
        ),
      ],
    );
  }

  Widget _buildColorPicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: AppTextStyles.label),
        SizedBox(height: 4.h),
        Row(
          children: [
            GestureDetector(
              onTap: () => _showColorPicker(context),
              child: Container(
                width: 36.r,
                height: 36.r,
                decoration: BoxDecoration(
                  color: Color(int.parse(colorHex, radix: 16)),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
              ),
            ),
            SizedBox(width: AppSizes.hGapS),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '#${colorHex.toUpperCase()}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusS),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSizes.gapS,
                    vertical: 4.h,
                  ),
                ),
                controller: TextEditingController(text: colorHex.toUpperCase()),
                onChanged: (v) {
                  final cleaned = v.replaceAll('#', '');
                  if (cleaned.length == 8 || cleaned.length == 6) {
                    onColorChanged(cleaned);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showColorPicker(BuildContext context) {
    Color pickerColor = Color(int.parse(colorHex, radix: 16));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pick a Color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: pickerColor,
            onColorChanged: (c) {
              pickerColor = c;
              onColorChanged(SignatureColors.toHex(c));
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
      ),
      child: child,
    );
  }
}
