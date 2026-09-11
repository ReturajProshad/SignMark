import 'package:file_picker/file_picker.dart';

class PickPdfUseCase {
  const PickPdfUseCase();

  Future<PlatformFile?> call() async {
    return FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }
}
