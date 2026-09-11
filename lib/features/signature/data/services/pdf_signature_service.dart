import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../../core/constants/pdf_defaults.dart';

class PdfSignatureService {
  const PdfSignatureService();

  Future<Uint8List> embedSignature({
    required String sourcePdfPath,
    required String name,
    required Uint8List fontFileBytes,
    required double fontSizePt,
    required bool isBold,
    required int colorArgb,
  }) async {
    final inputFile = File(sourcePdfPath);
    if (!await inputFile.exists()) {
      throw FileSystemException('Source PDF not found', sourcePdfPath);
    }

    final bytes = await inputFile.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);

    try {
      if (document.pages.count == 0) {
        throw StateError('PDF has no pages');
      }

      final page = document.pages[0];

      final font = PdfTrueTypeFont(
        fontFileBytes,
        fontSizePt,
        style: isBold ? PdfFontStyle.bold : PdfFontStyle.regular,
      );

      final color = _toPdfColor(colorArgb);
      final brush = PdfSolidBrush(color);

      final size = font.measureString(name);
      final textWidth = size.width;
      final textHeight = size.height;

      final pageWidth = page.size.width;
      final pageHeight = page.size.height;
      final bottomMargin = PdfDefaults.signatureBottomMarginPts;

      double x = (pageWidth - textWidth) / 2;
      double y = pageHeight - bottomMargin - textHeight;
      double drawWidth = textWidth;
      double drawHeight = textHeight;

      PdfTrueTypeFont actualFont = font;

      if (x < 0) {
        final scale = pageWidth / textWidth;
        final adjustedFontSize = fontSizePt * scale * 0.9;
        actualFont = PdfTrueTypeFont(
          fontFileBytes,
          adjustedFontSize,
          style: isBold ? PdfFontStyle.bold : PdfFontStyle.regular,
        );
        final adjustedSize = actualFont.measureString(name);
        drawWidth = adjustedSize.width;
        drawHeight = adjustedSize.height;
        x = (pageWidth - drawWidth) / 2;
        y = pageHeight - bottomMargin - drawHeight;
      }

      page.graphics.drawString(
        name,
        actualFont,
        brush: brush,
        bounds: ui.Rect.fromLTWH(x, y, drawWidth, drawHeight),
      );

      final outputBytes = await document.save();
      return Uint8List.fromList(outputBytes);
    } finally {
      document.dispose();
    }
  }

  PdfColor _toPdfColor(int argb) {
    final a = (argb >> 24) & 0xFF;
    final r = (argb >> 16) & 0xFF;
    final g = (argb >> 8) & 0xFF;
    final b = argb & 0xFF;
    return PdfColor(r, g, b, a);
  }
}
