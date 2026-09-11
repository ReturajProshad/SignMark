import 'dart:io';

import 'package:syncfusion_flutter_pdf/pdf.dart';

class GetPageCountUseCase {
  const GetPageCountUseCase();

  Future<int> call(String path) async {
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
