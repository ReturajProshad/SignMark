import 'dart:typed_data';

import '../../../../core/utils/file_naming.dart';
import '../../../../core/utils/save_pdf.dart';
import '../../domain/entities/watermark_config.dart';
import '../../domain/repositories/watermark_repository.dart';
import '../services/pdf_watermark_service.dart';

class WatermarkRepositoryImpl implements WatermarkRepository {
  WatermarkRepositoryImpl({required this.watermarkService});

  final PdfWatermarkService watermarkService;

  @override
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
  }) async {
    final outputBytes = await watermarkService.applyWatermark(
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

    final fileName = FileNaming.watermarked(sourcePdfPath);
    return savePdfBytes(outputBytes, fileName);
  }
}
