import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> _saveReceipt(String sourcePath) async {
  final dir = Directory(
    p.join((await getApplicationDocumentsDirectory()).path, 'receipts'),
  );
  await dir.create(recursive: true);
  final ext = p.extension(sourcePath).isEmpty ? '.jpg' : p.extension(sourcePath);
  final dest = p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}$ext');
  await File(sourcePath).copy(dest);
  return dest;
}

/// Lets the user take or choose a receipt photo and copies it into app storage.
/// Returns the saved file path, or null if cancelled.
Future<String?> pickReceipt(ImageSource source) async {
  final picked = await ImagePicker().pickImage(
    source: source,
    maxWidth: 1800,
    imageQuality: 85,
  );
  if (picked == null) return null;
  return _saveReceipt(picked.path);
}

/// Lets the user pick a receipt image via the document picker, which also
/// reaches apps like Google Photos that only expose photos through it.
/// Returns the saved file path, or null if cancelled.
Future<String?> pickReceiptFromFiles() async {
  final picked = await FilePicker.pickFiles(type: FileType.image);
  if (picked.isEmpty) return null;
  final path = picked.single.path;
  if (path == null) return null;
  return _saveReceipt(path);
}
