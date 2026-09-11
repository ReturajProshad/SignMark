import '../../domain/entities/pdf_source.dart';
import '../../domain/repositories/pdf_source_repository.dart';
import '../../domain/usecases/get_page_count_usecase.dart';
import '../../domain/usecases/pick_pdf_usecase.dart';

class PdfSourceRepositoryImpl implements PdfSourceRepository {
  PdfSourceRepositoryImpl({
    PickPdfUseCase? pickPdfUseCase,
    GetPageCountUseCase? getPageCountUseCase,
  }) : _pickPdfUseCase = pickPdfUseCase ?? const PickPdfUseCase(),
       _getPageCountUseCase =
           getPageCountUseCase ?? const GetPageCountUseCase();

  final PickPdfUseCase _pickPdfUseCase;
  final GetPageCountUseCase _getPageCountUseCase;

  @override
  Future<int> getPageCount(String path) => _getPageCountUseCase(path);

  @override
  Future<PdfSource?> pickAndInspect() async {
    final file = await _pickPdfUseCase();
    if (file == null || file.path == null) return null;

    final path = file.path!;
    final pageCount = await getPageCount(path);

    return PdfSource(path: path, fileName: file.name, pageCount: pageCount);
  }
}
