import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Where book cover images are stored.
Future<Directory> coversDir() async => Directory(
  p.join((await getApplicationDocumentsDirectory()).path, 'covers'),
);

/// Lets the user take or choose a book cover and copies it into app storage.
/// Returns the saved file path, or null if cancelled.
Future<String?> pickCover(ImageSource source) async {
  final picked = await ImagePicker().pickImage(
    source: source,
    maxWidth: 800,
    imageQuality: 85,
  );
  if (picked == null) return null;
  final dir = await coversDir();
  await dir.create(recursive: true);
  final dest = p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
  await File(picked.path).copy(dest);
  return dest;
}

/// Removes a cover file we stored; ignores files that are already gone.
Future<void> deleteCover(String? path) async {
  if (path == null) return;
  try {
    await File(path).delete();
  } on FileSystemException {
    // Already gone (e.g. restored from a backup): nothing to do.
  }
}
