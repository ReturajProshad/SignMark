import 'dart:typed_data';

import '../entities/watermark_config.dart';

abstract class WatermarkRepository {
  Future<String> applyWatermark({
    required String sourcePdfPath,
    required String text,
    required Uint8List fontFileBytes,
    required double fontSizePt,
    required TextStyleOption style,
    required int colorArgb,
    required AnchorPosition anchor,
    required WatermarkLayer layer,
    required double opacityPercent,
    required double rotationDegrees,
    required int pageFrom,
    required int pageTo,
  });
}
