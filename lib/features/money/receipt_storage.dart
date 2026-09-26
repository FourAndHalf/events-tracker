import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Lets the user take or choose a receipt photo and copies it into app storage.
/// Returns the saved file path, or null if cancelled.
Future<String?> pickReceipt(ImageSource source) async {
  final picked = await ImagePicker().pickImage(
    source: source,
    maxWidth: 1800,
    imageQuality: 85,
  );
  if (picked == null) return null;
  final dir = Directory(
    p.join((await getApplicationDocumentsDirectory()).path, 'receipts'),
  );
  await dir.create(recursive: true);
  final dest = p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
  await File(picked.path).copy(dest);
  return dest;
}
