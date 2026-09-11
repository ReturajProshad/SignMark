import 'dart:typed_data';

import '../repositories/signature_repository.dart';

class EmbedSignatureUseCase {
  const EmbedSignatureUseCase(this._repository);

  final SignatureRepository _repository;

  Future<String> call({
    required String sourcePdfPath,
    required String name,
    required Uint8List fontFileBytes,
    required double fontSizePt,
    required bool isBold,
    required int colorArgb,
  }) {
    return _repository.embedSignature(
      sourcePdfPath: sourcePdfPath,
      name: name,
      fontFileBytes: fontFileBytes,
      fontSizePt: fontSizePt,
      isBold: isBold,
      colorArgb: colorArgb,
    );
  }
}
