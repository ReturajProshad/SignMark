import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Landing screen: choose to add a typed signature or a text watermark.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSizes.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSizes.gapXl),
              Text('SignMark', style: AppTextStyles.title),
              SizedBox(height: AppSizes.gapXs),
              Text(
                'Add a typed signature or a text watermark to your PDF.',
                style: AppTextStyles.label,
              ),
              SizedBox(height: AppSizes.gapXl),
              _HomeCard(
                icon: Icons.draw_outlined,
                title: 'Add Signature',
                subtitle: 'Type your name and place it on page 1.',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.signature),
              ),
              SizedBox(height: AppSizes.gapM),
              _HomeCard(
                icon: Icons.branding_watermark_outlined,
                title: 'Add Watermark',
                subtitle: 'Overlay text across a range of pages.',
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRouter.watermark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.all(Radius.circular(AppSizes.radiusL));
    return Material(
      color: AppColors.surfaceVariant,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSizes.cardPadding),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSizes.gapS),
                decoration: BoxDecoration(
                  color: AppColors.primaryRedTint,
                  borderRadius:
                      BorderRadius.all(Radius.circular(AppSizes.radiusM)),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryRed,
                  size: AppSizes.iconM,
                ),
              ),
              SizedBox(width: AppSizes.hGapM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.subtitle),
                    SizedBox(height: AppSizes.gapXs),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
                size: AppSizes.iconM,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
