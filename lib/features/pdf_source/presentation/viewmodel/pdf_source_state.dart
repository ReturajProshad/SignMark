import 'package:flutter/foundation.dart';

import '../../domain/entities/pdf_source.dart';

@immutable
class PdfSourceState {
  const PdfSourceState({
    this.pdfSource,
    this.isPicking = false,
    this.pickError,
  });

  /// The currently picked PDF with its real page count.
  final PdfSource? pdfSource;

  /// True while the file picker is open or the page count is being parsed.
  final bool isPicking;

  /// Error message if picking or parsing failed.
  final String? pickError;

  bool get hasPdf => pdfSource != null;

  PdfSourceState copyWith({
    PdfSource? pdfSource,
    bool? isPicking,
    String? pickError,
    bool clearPdfSource = false,
    bool clearPickError = false,
  }) {
    return PdfSourceState(
      pdfSource: clearPdfSource ? null : (pdfSource ?? this.pdfSource),
      isPicking: isPicking ?? this.isPicking,
      pickError: clearPickError ? null : (pickError ?? this.pickError),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfSourceState &&
          runtimeType == other.runtimeType &&
          pdfSource == other.pdfSource &&
          isPicking == other.isPicking &&
          pickError == other.pickError;

  @override
  int get hashCode => Object.hash(pdfSource, isPicking, pickError);
}
