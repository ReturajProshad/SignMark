import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/pdf_defaults.dart';
import '../../domain/entities/watermark_config.dart';

@immutable
class WatermarkState {
  const WatermarkState({
    this.text = 'Watermark',
    this.fontIndex = 0,
    this.fontSizePt = PdfDefaults.watermarkFontSize,
    this.style = TextStyleOption.regular,
    this.colorHex = _defaultColorHex,
    this.anchor = AnchorPosition.middleCenter,
    this.layer = WatermarkLayer.over,
    this.opacityPercent = 50.0,
    this.rotationDegrees = PdfDefaults.watermarkRotationDegrees,
    this.pageFrom = 1,
    this.pageTo = 1,
    this.totalPages = 0,
    this.saveStatus = const AsyncValue<String>.data(''),
  });

  static const String _defaultColorHex = 'FF1A1A1A';

  final String text;
  final int fontIndex;
  final double fontSizePt;
  final TextStyleOption style;
  final String colorHex;
  final AnchorPosition anchor;
  final WatermarkLayer layer;
  final double opacityPercent;
  final double rotationDegrees;
  final int pageFrom;
  final int pageTo;
  final int totalPages;
  final AsyncValue<String> saveStatus;

  Color get color => Color(int.parse(colorHex, radix: 16));

  bool get hasValidRange => pageFrom <= pageTo && pageFrom >= 1 && pageTo <= totalPages && totalPages > 0;

  bool get canSubmit => text.trim().isNotEmpty && hasValidRange;

  WatermarkState copyWith({
    String? text,
    int? fontIndex,
    double? fontSizePt,
    TextStyleOption? style,
    String? colorHex,
    AnchorPosition? anchor,
    WatermarkLayer? layer,
    double? opacityPercent,
    double? rotationDegrees,
    int? pageFrom,
    int? pageTo,
    int? totalPages,
    AsyncValue<String>? saveStatus,
  }) {
    return WatermarkState(
      text: text ?? this.text,
      fontIndex: fontIndex ?? this.fontIndex,
      fontSizePt: fontSizePt ?? this.fontSizePt,
      style: style ?? this.style,
      colorHex: colorHex ?? this.colorHex,
      anchor: anchor ?? this.anchor,
      layer: layer ?? this.layer,
      opacityPercent: opacityPercent ?? this.opacityPercent,
      rotationDegrees: rotationDegrees ?? this.rotationDegrees,
      pageFrom: pageFrom ?? this.pageFrom,
      pageTo: pageTo ?? this.pageTo,
      totalPages: totalPages ?? this.totalPages,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatermarkState &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          fontIndex == other.fontIndex &&
          fontSizePt == other.fontSizePt &&
          style == other.style &&
          colorHex == other.colorHex &&
          anchor == other.anchor &&
          layer == other.layer &&
          opacityPercent == other.opacityPercent &&
          rotationDegrees == other.rotationDegrees &&
          pageFrom == other.pageFrom &&
          pageTo == other.pageTo &&
          totalPages == other.totalPages &&
          saveStatus == other.saveStatus;

  @override
  int get hashCode => Object.hash(
        text,
        fontIndex,
        fontSizePt,
        style,
        colorHex,
        anchor,
        layer,
        opacityPercent,
        rotationDegrees,
        pageFrom,
        pageTo,
        totalPages,
        saveStatus,
      );
}
