import 'package:flutter/material.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/signature/presentation/screens/draw_signature_screen.dart';
import '../../features/watermark/presentation/screens/pdf_watermark_screen.dart';

/// Simple named-route table driven by `onGenerateRoute`.
/// `go_router` is intentionally not used — the app has three flat routes and
/// no deep-linking requirement
abstract final class AppRouter {
  static const String home = '/';
  static const String signature = '/signature';
  static const String watermark = '/watermark';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      case signature:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const DrawSignatureScreen(),
        );
      case watermark:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PdfWatermarkScreen(),
        );
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
