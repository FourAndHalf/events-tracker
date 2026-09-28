import 'dart:io';

import 'package:image/image.dart' as img;

/// Downscales the image at [sourcePath] to at most [maxDimension] on its
/// longest side and writes a JPEG at [destPath]. If the bytes can't be
/// decoded as an image, copies them through unchanged.
Future<void> compressImageTo(
  String sourcePath,
  String destPath, {
  int maxDimension = 1800,
  int quality = 85,
}) async {
  final bytes = await File(sourcePath).readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    await File(sourcePath).copy(destPath);
    return;
  }
  final oriented = img.bakeOrientation(decoded);
  final resized =
      oriented.width > maxDimension || oriented.height > maxDimension
      ? img.copyResize(
          oriented,
          width: oriented.width >= oriented.height ? maxDimension : null,
          height: oriented.height > oriented.width ? maxDimension : null,
        )
      : oriented;
  await File(destPath).writeAsBytes(img.encodeJpg(resized, quality: quality));
}
