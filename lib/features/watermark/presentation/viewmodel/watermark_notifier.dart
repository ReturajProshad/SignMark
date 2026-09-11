import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/watermark_config.dart';
import 'watermark_state.dart';

final watermarkNotifierProvider =
    NotifierProvider<WatermarkNotifier, WatermarkState>(WatermarkNotifier.new);

class WatermarkNotifier extends Notifier<WatermarkState> {
  @override
  WatermarkState build() => const WatermarkState();

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
}
