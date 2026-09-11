import 'dart:typed_data';

import '../../../../core/utils/file_naming.dart';
import '../../../../core/utils/save_pdf.dart';
import '../../domain/repositories/signature_repository.dart';
import '../services/pdf_signature_service.dart';

class SignatureRepositoryImpl implements SignatureRepository {
  SignatureRepositoryImpl({required this.signatureService});

  final PdfSignatureService signatureService;

  @override
  Future<String> embedSignature({
    required String sourcePdfPath,
    required String name,
    required Uint8List fontFileBytes,
    required double fontSizePt,
    required bool isBold,
    required int colorArgb,
  }) async {
    final outputBytes = await signatureService.embedSignature(
      sourcePdfPath: sourcePdfPath,
      name: name,
      fontFileBytes: fontFileBytes,
      fontSizePt: fontSizePt,
      isBold: isBold,
      colorArgb: colorArgb,
    );

    final fileName = FileNaming.signed(sourcePdfPath);
    return savePdfBytes(outputBytes, fileName);
  }
}
