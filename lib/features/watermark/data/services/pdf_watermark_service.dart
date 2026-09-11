import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../core/constants/pdf_defaults.dart';
import '../../domain/entities/watermark_config.dart';

class PdfWatermarkService {
  const PdfWatermarkService();

  Future<Uint8List> applyWatermark({
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
    final inputFile = File(sourcePdfPath);
    if (!await inputFile.exists()) {
      throw FileSystemException('Source PDF not found', sourcePdfPath);
    }

    final bytes = await inputFile.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);

    try {
      final totalPages = document.pages.count;
      if (totalPages == 0) {
        throw StateError('PDF has no pages');
      }

      final font = _buildFont(fontFileBytes, fontSizePt, style);
      final color = _toPdfColor(colorArgb);
      final brush = PdfSolidBrush(color);

      final size = font.measureString(text);
      final textWidth = size.width;
      final textHeight = size.height;

      final margin = PdfDefaults.watermarkBottomMarginPts;

      final startPage = pageFrom - 1;
      final endPage = (pageTo - 1).clamp(0, totalPages - 1);

      for (var i = startPage; i <= endPage; i++) {
        final page = document.pages[i];
        final pageWidth = page.size.width;
        final pageHeight = page.size.height;

        final x = _computeX(anchor, pageWidth, textWidth, margin);
        final y = _computeY(anchor, pageHeight, textHeight, margin);

        final graphics = _getGraphics(page, layer);

        final alpha = opacityPercent / 100;
        graphics.setTransparency(alpha, alphaBrush: alpha);

        if (rotationDegrees != 0) {
          graphics.save();
          final centerX = x + textWidth / 2;
          final centerY = y + textHeight / 2;
          graphics.translateTransform(centerX, centerY);
          graphics.rotateTransform(rotationDegrees);
          graphics.translateTransform(-centerX, -centerY);
        }

        graphics.drawString(
          text,
          font,
          brush: brush,
          bounds: ui.Rect.fromLTWH(x, y, textWidth, textHeight),
        );

        if (rotationDegrees != 0) {
          graphics.restore();
        }
      }

      final outputBytes = await document.save();
      return Uint8List.fromList(outputBytes);
    } finally {
      document.dispose();
    }
  }

  PdfGraphics _getGraphics(PdfPage page, WatermarkLayer layer) {
    if (layer == WatermarkLayer.under) {
      final newLayer = page.layers.add();
      return newLayer.graphics;
    }
    return page.graphics;
  }

  double _computeX(AnchorPosition anchor, double pageWidth, double textWidth, double margin) {
    switch (anchor) {
      case AnchorPosition.topLeft:
      case AnchorPosition.middleLeft:
      case AnchorPosition.bottomLeft:
        return margin;
      case AnchorPosition.topCenter:
      case AnchorPosition.middleCenter:
      case AnchorPosition.bottomCenter:
        return (pageWidth - textWidth) / 2;
      case AnchorPosition.topRight:
      case AnchorPosition.middleRight:
      case AnchorPosition.bottomRight:
        return pageWidth - textWidth - margin;
    }
  }

  double _computeY(AnchorPosition anchor, double pageHeight, double textHeight, double margin) {
    switch (anchor) {
      case AnchorPosition.topLeft:
      case AnchorPosition.topCenter:
      case AnchorPosition.topRight:
        return margin;
      case AnchorPosition.middleLeft:
      case AnchorPosition.middleCenter:
      case AnchorPosition.middleRight:
        return (pageHeight - textHeight) / 2;
      case AnchorPosition.bottomLeft:
      case AnchorPosition.bottomCenter:
      case AnchorPosition.bottomRight:
        return pageHeight - textHeight - margin;
    }
  }

  PdfTrueTypeFont _buildFont(
    Uint8List fontBytes,
    double size,
    TextStyleOption style,
  ) {
    PdfFontStyle pdfStyle;
    switch (style) {
      case TextStyleOption.regular:
        pdfStyle = PdfFontStyle.regular;
      case TextStyleOption.italic:
        pdfStyle = PdfFontStyle.italic;
      case TextStyleOption.bold:
        pdfStyle = PdfFontStyle.bold;
      case TextStyleOption.boldItalic:
        pdfStyle = PdfFontStyle.bold;
    }
    return PdfTrueTypeFont(fontBytes, size, style: pdfStyle);
  }

  PdfColor _toPdfColor(int argb) {
    final r = (argb >> 16) & 0xFF;
    final g = (argb >> 8) & 0xFF;
    final b = argb & 0xFF;
    return PdfColor(r, g, b);
  }
}
