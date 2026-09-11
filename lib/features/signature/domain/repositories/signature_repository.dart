import 'dart:typed_data';

abstract class SignatureRepository {
  Future<String> embedSignature({
    required String sourcePdfPath,
    required String name,
    required Uint8List fontFileBytes,
    required double fontSizePt,
    required bool isBold,
    required int colorArgb,
  });
}
