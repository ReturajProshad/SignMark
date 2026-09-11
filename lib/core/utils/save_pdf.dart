import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const String _outputSubDir = 'SignMark/editedPdf';

Future<String> savePdfBytes(Uint8List bytes, String suggestedFileName) async {
  final directory = await _resolveDirectory();
  final file = File('${directory.path}/$suggestedFileName');
  await file.writeAsBytes(bytes);
  return file.path;
}

Future<Directory> _resolveDirectory() async {
  if (Platform.isAndroid) {
    await _requestStoragePermissionBestEffort();

    final publicDir = await _tryPublicDocumentsDir();
    if (publicDir != null) {
      return publicDir;
    }

    final external = await getExternalStorageDirectory();
    if (external != null) {
      final fallback = Directory('${external.path}/$_outputSubDir');
      await fallback.create(recursive: true);
      return fallback;
    }
  }

  final documents = await getApplicationDocumentsDirectory();
  final dir = Directory('${documents.path}/$_outputSubDir');
  await dir.create(recursive: true);
  return dir;
}

Future<void> _requestStoragePermissionBestEffort() async {
  try {
    await Permission.storage.request();
  } catch (_) {}
}

Future<Directory?> _tryPublicDocumentsDir() async {
  try {
    final external = await getExternalStorageDirectory();
    final storageRoot = external?.path.split('/Android/data').first;
    if (storageRoot == null || storageRoot.isEmpty) {
      return null;
    }

    final dir = Directory('$storageRoot/Documents/$_outputSubDir');
    await dir.create(recursive: true);

    final probe = File('${dir.path}/.write_probe');
    await probe.writeAsBytes(const <int>[]);
    await probe.delete();

    return dir;
  } catch (_) {
    return null;
  }
}
