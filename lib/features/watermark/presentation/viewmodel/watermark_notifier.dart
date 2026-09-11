import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../signature/domain/entities/signature_config.dart';
import '../../data/repositories/watermark_repository_impl.dart';
import '../../data/services/pdf_watermark_service.dart';
import '../../domain/entities/watermark_config.dart';
import '../../domain/usecases/apply_watermark_usecase.dart';
import 'watermark_state.dart';

final watermarkNotifierProvider =
    NotifierProvider<WatermarkNotifier, WatermarkState>(WatermarkNotifier.new);

class WatermarkNotifier extends Notifier<WatermarkState> {
  late final ApplyWatermarkUseCase _applyWatermarkUseCase;

  @override
  WatermarkState build() {
    _applyWatermarkUseCase = ApplyWatermarkUseCase(
      WatermarkRepositoryImpl(watermarkService: const PdfWatermarkService()),
    );
    return const WatermarkState();
  }

  void setText(String value) {
    state = state.copyWith(text: value);
  }

  void setFontIndex(int index) {
    state = state.copyWith(fontIndex: index);
  }

  void setFontSize(double size) {
    state = state.copyWith(fontSizePt: size);
  }

  void setStyleOption(String value) {
    final option = TextStyleOption.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TextStyleOption.regular,
    );
    state = state.copyWith(style: option);
  }

  void setColor(String hex) {
    state = state.copyWith(colorHex: hex);
  }

  void setAnchor(AnchorPosition anchor) {
    state = state.copyWith(anchor: anchor);
  }

  void setLayer(WatermarkLayer layer) {
    state = state.copyWith(layer: layer);
  }

  void setOpacity(double value) {
    state = state.copyWith(opacityPercent: value);
  }

  void setRotation(double value) {
    state = state.copyWith(rotationDegrees: value);
  }

  void setPageFrom(int value) {
    state = state.copyWith(pageFrom: value);
  }

  void setPageTo(int value) {
    state = state.copyWith(pageTo: value);
  }

  void setTotalPages(int count) {
    final clampedFrom = state.pageFrom.clamp(1, count);
    final clampedTo = state.pageTo.clamp(1, count);
    Future.microtask(() {
      state = state.copyWith(
        totalPages: count,
        pageFrom: clampedFrom,
        pageTo: clampedTo,
      );
    });
  }

  void setSaveStatus(AsyncValue<String> status) {
    state = state.copyWith(saveStatus: status);
  }

  Future<void> applyWatermark(String sourcePdfPath) async {
    state = state.copyWith(saveStatus: const AsyncValue<String>.loading());

    try {
      final selectedFont = state.fontIndex;
      final fontBytes = await _loadFontBytes(selectedFont);

      final color = state.color;
      final colorArgb = color.toARGB32();

      final savedPath = await _applyWatermarkUseCase.call(
        sourcePdfPath: sourcePdfPath,
        text: state.text.trim(),
        fontFileBytes: fontBytes,
        fontSizePt: state.fontSizePt,
        style: state.style,
        colorArgb: colorArgb,
        anchor: state.anchor,
        layer: state.layer,
        opacityPercent: state.opacityPercent,
        rotationDegrees: state.rotationDegrees,
        pageFrom: state.pageFrom,
        pageTo: state.pageTo,
      );

      state = state.copyWith(saveStatus: AsyncValue<String>.data(savedPath));
    } catch (e, st) {
      state = state.copyWith(saveStatus: AsyncValue<String>.error(e, st));
    }
  }

  Future<Uint8List> _loadFontBytes(int fontIndex) async {
    final font = SignatureFont.all[fontIndex];
    final assetPath = 'assets/fonts/${font.assetFileName}';
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
  }
}
