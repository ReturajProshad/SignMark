/// Represents a picked PDF file with its metadata.
class PdfSource {
  const PdfSource({
    required this.path,
    required this.fileName,
    required this.pageCount,
  });

  final String path;

  final String fileName;

  final int pageCount;

  PdfSource copyWith({String? path, String? fileName, int? pageCount}) {
    return PdfSource(
      path: path ?? this.path,
      fileName: fileName ?? this.fileName,
      pageCount: pageCount ?? this.pageCount,
    );
  }
}
