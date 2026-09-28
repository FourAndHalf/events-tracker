import 'dart:io';
import 'dart:math';

import 'package:events_tracker/core/media/image_compress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('image_compress_test');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('downscales an oversized image and re-encodes as JPEG', () async {
    final random = Random(1);
    final source = img.Image(width: 2000, height: 1500);
    for (var y = 0; y < source.height; y++) {
      for (var x = 0; x < source.width; x++) {
        source.setPixelRgb(
          x,
          y,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        );
      }
    }
    final sourcePath = p.join(tempDir.path, 'source.png');
    await File(sourcePath).writeAsBytes(img.encodePng(source, level: 0));

    final destPath = p.join(tempDir.path, 'dest.jpg');
    await compressImageTo(sourcePath, destPath, maxDimension: 900);

    final result = img.decodeImage(await File(destPath).readAsBytes())!;
    expect(result.width, 900);
    expect(result.height, 675);
    expect(
      await File(destPath).length(),
      lessThan(await File(sourcePath).length()),
    );
  });

  test('leaves an already-small image at its original size', () async {
    final source = img.Image(width: 400, height: 300);
    img.fill(source, color: img.ColorRgb8(10, 20, 30));
    final sourcePath = p.join(tempDir.path, 'small.png');
    await File(sourcePath).writeAsBytes(img.encodePng(source));

    final destPath = p.join(tempDir.path, 'small_dest.jpg');
    await compressImageTo(sourcePath, destPath, maxDimension: 1800);

    final result = img.decodeImage(await File(destPath).readAsBytes())!;
    expect(result.width, 400);
    expect(result.height, 300);
  });
}
