import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TextImageTabs extends StatelessWidget {
  const TextImageTabs({
    super.key,
    required this.controller,
  });

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      indicatorColor: AppColors.primaryRed,
      labelColor: AppColors.primaryRed,
      unselectedLabelColor: AppColors.textSecondary,
      tabs: const [
        Tab(text: 'Text'),
        Tab(text: 'Image'),
      ],
    );
  }
}
