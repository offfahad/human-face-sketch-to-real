// // Helper method for mobile
// import 'dart:io';
// import 'dart:math';
// import 'package:file_picker/file_picker.dart';
// import 'package:image/image.dart' as img;

// Future<bool> isWhiteBackgroundBlackLines(File file) async {
//   final bytes = await file.readAsBytes();
//   final image = img.decodeImage(bytes)!;

//   // Sample some pixels to check if it's mostly white with black lines
//   final samplePoints = [
//     const Point(10, 10), // top-left corner
//     const Point(246, 10), // top-right corner
//     const Point(10, 246), // bottom-left corner
//     const Point(246, 246), // bottom-right corner
//     const Point(128, 128), // center
//   ];

//   int whitePixels = 0;
//   int blackPixels = 0;

//   for (var point in samplePoints) {
//     final pixel = image.getPixel(point.x, point.y);
//     final r = pixel.r;
//     final g = pixel.g;
//     final b = pixel.b;

//     // Check if pixel is white (all channels > 240)
//     if (r > 240 && g > 240 && b > 240) {
//       whitePixels++;
//     }
//     // Check if pixel is black (all channels < 15)
//     else if (r < 15 && g < 15 && b < 15) {
//       blackPixels++;
//     }
//   }

//   // If most sampled points are white with some black, it's likely a sketch
//   return whitePixels >= 3 && blackPixels >= 1;
// }

// // Helper method for web
// Future<bool> isWhiteBackgroundBlackLinesWeb(PlatformFile file) async {
//   final image = img.decodeImage(file.bytes!)!;

//   // Same sampling logic as above
//   final samplePoints = [
//     const Point(10, 10),
//     const Point(246, 10),
//     const Point(10, 246),
//     const Point(246, 246),
//     const Point(128, 128),
//   ];

//   int whitePixels = 0;
//   int blackPixels = 0;

//   for (var point in samplePoints) {
//     final pixel = image.getPixel(point.x, point.y);
//     final r = pixel.r;
//     final g = pixel.g;
//     final b = pixel.b;

//     if (r > 240 && g > 240 && b > 240) {
//       whitePixels++;
//     } else if (r < 15 && g < 15 && b < 15) {
//       blackPixels++;
//     }
//   }

//   return whitePixels >= 3 && blackPixels >= 1;
// }
