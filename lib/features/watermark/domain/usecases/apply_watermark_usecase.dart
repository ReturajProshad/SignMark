import 'dart:typed_data';

import '../entities/watermark_config.dart';
import '../repositories/watermark_repository.dart';

class ApplyWatermarkUseCase {
  const ApplyWatermarkUseCase(this._repository);

  final WatermarkRepository _repository;

  Future<String> call({
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
  }) {
    return _repository.applyWatermark(
      sourcePdfPath: sourcePdfPath,
      text: text,
      fontFileBytes: fontFileBytes,
      fontSizePt: fontSizePt,
      style: style,
      colorArgb: colorArgb,
      anchor: anchor,
      layer: layer,
      opacityPercent: opacityPercent,
      rotationDegrees: rotationDegrees,
      pageFrom: pageFrom,
      pageTo: pageTo,
    );
  }
}
