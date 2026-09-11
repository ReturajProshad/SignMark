/// Builds output file names for saved PDFs. Framework-free so it can be unit-tested and reused across features
abstract final class FileNaming {
  static const String _pdfExt = '.pdf';

  /// `<base>_signed.pdf`
  static String signed(String originalFileName) =>
      _withSuffix(originalFileName, '_signed');

  /// `<base>_watermarked.pdf`
  static String watermarked(String originalFileName) =>
      _withSuffix(originalFileName, '_watermarked');

  static String _withSuffix(String originalFileName, String suffix) {
    final base = stripPdfExtension(originalFileName);
    return '$base$suffix$_pdfExt';
  }

  /// Returns the file name without any leading directory path and without a
  /// trailing `.pdf` extension (case-insensitive).
  static String stripPdfExtension(String fileName) {
    final name = fileName.split(RegExp(r'[\\/]')).last;
    if (name.toLowerCase().endsWith(_pdfExt)) {
      return name.substring(0, name.length - _pdfExt.length);
    }
    return name;
  }
}
