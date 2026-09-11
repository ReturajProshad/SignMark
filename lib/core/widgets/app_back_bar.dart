import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Shared back-arrow + title app bar used on both feature screens
/// (see `master_plan/04_design_system.md`).
class AppBackBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBackBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const BackButton(),
      title: Text(title, style: AppTextStyles.subtitle),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
