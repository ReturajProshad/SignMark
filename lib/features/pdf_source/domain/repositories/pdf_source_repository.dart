import '../entities/pdf_source.dart';

abstract class PdfSourceRepository {
  Future<int> getPageCount(String path);
  Future<PdfSource?> pickAndInspect();
}
