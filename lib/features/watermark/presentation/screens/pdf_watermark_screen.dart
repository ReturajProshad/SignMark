import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_bar.dart';

/// Watermark screen.
///
/// This is a scaffold placeholder so end-to-end routing works from Phase 1.
/// The Text-tab UI is built in Phase 5 and the PDF embed logic in Phase 6.
class PdfWatermarkScreen extends StatelessWidget {
  const PdfWatermarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackBar(title: 'Add Watermark'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.branding_watermark_outlined,
                size: AppSizes.iconL,
                color: AppColors.disabled,
              ),
              SizedBox(height: AppSizes.gapM),
              Text('Watermark builder', style: AppTextStyles.subtitle),
              SizedBox(height: AppSizes.gapXs),
              Text(
                'Coming in Phase 5 (UI) and Phase 6 (PDF embed).',
                style: AppTextStyles.label,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
