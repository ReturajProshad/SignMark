import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/signature_repository_impl.dart';
import '../../data/services/pdf_signature_service.dart';
import '../../domain/usecases/embed_signature_usecase.dart';
import 'signature_state.dart';

export 'signature_state.dart';

final signatureNotifierProvider =
    NotifierProvider<SignatureNotifier, SignatureState>(SignatureNotifier.new);

class SignatureNotifier extends Notifier<SignatureState> {
  late final EmbedSignatureUseCase _embedSignatureUseCase;

  @override
  SignatureState build() {
    _embedSignatureUseCase = EmbedSignatureUseCase(
      SignatureRepositoryImpl(
        signatureService: const PdfSignatureService(),
      ),
    );
    return const SignatureState();
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setFontIndex(int index) {
    state = state.copyWith(fontIndex: index);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSizePt: size);
  }

  void toggleBold() {
    state = state.copyWith(isBold: !state.isBold);
  }

  void setColor(String hex) {
    state = state.copyWith(colorHex: hex);
  }

  Future<void> embedSignature(String sourcePdfPath) async {
    state = state.copyWith(saveStatus: const AsyncValue<String>.loading());

    try {
      final selectedFont = state.selectedFont;
      final fontBytes = await _loadFontBytes(selectedFont.assetFileName);

      final color = state.color;
      final colorArgb = color.toARGB32();

      final savedPath = await _embedSignatureUseCase.call(
        sourcePdfPath: sourcePdfPath,
        name: state.name.trim(),
        fontFileBytes: fontBytes,
        fontSizePt: state.fontSizePt,
        isBold: state.isBold,
        colorArgb: colorArgb,
      );

      state = state.copyWith(
        saveStatus: AsyncValue<String>.data(savedPath),
      );
    } catch (e, st) {
      state = state.copyWith(
        saveStatus: AsyncValue<String>.error(e, st),
      );
    }
  }

  Future<Uint8List> _loadFontBytes(String fontFamily) async {
    final assetPath = 'assets/fonts/$fontFamily';
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
  }
}
