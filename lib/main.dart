import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  // Riverpod is the single source of truth for app/feature state.
  // No SyncfusionLicense.registerLicense() call is needed: Syncfusion Flutter
  // packages (v18.3.0.x+) require no license key in code and produce no trial
  // watermark. Community License eligibility is documented in the README.
  runApp(const ProviderScope(child: SignMarkApp()));
}
