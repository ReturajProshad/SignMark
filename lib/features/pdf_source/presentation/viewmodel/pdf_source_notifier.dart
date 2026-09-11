import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/pdf_source_repository.dart';
import '../../data/repositories/pdf_source_repository_impl.dart';
import 'pdf_source_state.dart';

/// Riverpod provider for the PDF source feature.
final pdfSourceNotifierProvider =
    NotifierProvider<PdfSourceNotifier, PdfSourceState>(PdfSourceNotifier.new);

class PdfSourceNotifier extends Notifier<PdfSourceState> {
  late final PdfSourceRepository _repository;

  @override
  PdfSourceState build() {
    _repository = PdfSourceRepositoryImpl();
    return const PdfSourceState();
  }

  Future<void> pickPdf() async {
    state = state.copyWith(isPicking: true, clearPickError: true);

    try {
      final source = await _repository.pickAndInspect();
      if (source == null) {
        state = state.copyWith(isPicking: false);
        return;
      }
      state = state.copyWith(
        pdfSource: source,
        isPicking: false,
        clearPickError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isPicking: false,
        pickError: 'Failed to read PDF: $e',
      );
    }
  }

  void clearPdf() {
    state = const PdfSourceState();
  }
}
