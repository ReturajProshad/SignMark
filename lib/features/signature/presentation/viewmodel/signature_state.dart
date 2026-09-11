import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/pdf_defaults.dart';
import '../../domain/entities/signature_config.dart';

@immutable
class SignatureState {
  const SignatureState({
    this.name = '',
    this.fontIndex = 0,
    this.fontSizePt = PdfDefaults.signatureFontSize,
    this.isBold = false,
    this.colorHex = _defaultColorHex,
    this.saveStatus = const AsyncValue<String>.data(''),
  });

  static const String _defaultColorHex = 'FF1A1A1A';

  final String name;
  final int fontIndex;
  final double fontSizePt;
  final bool isBold;
  final String colorHex;
  final AsyncValue<String> saveStatus;

  SignatureFont get selectedFont => SignatureFont.all[fontIndex];

  Color get color => Color(int.parse(colorHex, radix: 16));

  bool get canSubmit => name.trim().isNotEmpty;

  SignatureState copyWith({
    String? name,
    int? fontIndex,
    double? fontSizePt,
    bool? isBold,
    String? colorHex,
    AsyncValue<String>? saveStatus,
  }) {
    return SignatureState(
      name: name ?? this.name,
      fontIndex: fontIndex ?? this.fontIndex,
      fontSizePt: fontSizePt ?? this.fontSizePt,
      isBold: isBold ?? this.isBold,
      colorHex: colorHex ?? this.colorHex,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignatureState &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          fontIndex == other.fontIndex &&
          fontSizePt == other.fontSizePt &&
          isBold == other.isBold &&
          colorHex == other.colorHex &&
          saveStatus == other.saveStatus;

  @override
  int get hashCode =>
      Object.hash(name, fontIndex, fontSizePt, isBold, colorHex, saveStatus);
}
