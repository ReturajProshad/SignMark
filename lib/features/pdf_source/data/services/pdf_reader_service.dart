import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Low-level Syncfusion-backed service for reading PDF metadata.  Lives in `data/services/` because it directly imports the PDF SDK

class PdfReaderService {
  const PdfReaderService();
  Future<int> getPageCount(String path) async {
    final inputFile = File(path);
    final bytes = await inputFile.readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    try {
      return document.pages.count;
    } finally {
      document.dispose();
    }
  }
}
