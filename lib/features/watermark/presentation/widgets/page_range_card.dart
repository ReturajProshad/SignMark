import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PageRangeCard extends StatelessWidget {
  const PageRangeCard({
    super.key,
    required this.pageFrom,
    required this.pageTo,
    required this.totalPages,
    required this.onPageFromChanged,
    required this.onPageToChanged,
    this.validationError,
  });

  final int pageFrom;
  final int pageTo;
  final int totalPages;
  final ValueChanged<int> onPageFromChanged;
  final ValueChanged<int> onPageToChanged;
  final String? validationError;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusM)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Page Range', style: AppTextStyles.subtitle),
          SizedBox(height: AppSizes.gapXs),
          Text(
            'Total pages: $totalPages',
            style: AppTextStyles.caption,
          ),
          SizedBox(height: AppSizes.gapS),
          Row(
            children: [
              Expanded(
                child: _buildPageInput(
                  label: 'From',
                  value: pageFrom,
                  onChanged: onPageFromChanged,
                ),
              ),
              SizedBox(width: AppSizes.hGapM),
              Expanded(
                child: _buildPageInput(
                  label: 'To',
                  value: pageTo,
                  onChanged: onPageToChanged,
                ),
              ),
            ],
          ),
          if (validationError != null) ...[
            SizedBox(height: AppSizes.gapXs),
            Text(
              validationError!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPageInput({
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),
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
          controller: TextEditingController(text: value.toString()),
          onChanged: (v) {
            final parsed = int.tryParse(v);
            if (parsed != null && parsed >= 1) {
              onChanged(parsed);
            }
          },
        ),
      ],
    );
  }
}
