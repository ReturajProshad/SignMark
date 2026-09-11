import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_back_bar.dart';

/// Signature screen.
///
/// This is a scaffold placeholder so end-to-end routing works from Phase 1.
/// The Type-tab UI is built in Phase 3 and the PDF embed logic in Phase 4.
class DrawSignatureScreen extends StatelessWidget {
  const DrawSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBackBar(title: 'Add Signature'),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.draw_outlined,
                size: AppSizes.iconL,
                color: AppColors.disabled,
              ),
              SizedBox(height: AppSizes.gapM),
              Text('Signature builder', style: AppTextStyles.subtitle),
              SizedBox(height: AppSizes.gapXs),
              Text(
                'Coming in Phase 3 (UI) and Phase 4 (PDF embed).',
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
