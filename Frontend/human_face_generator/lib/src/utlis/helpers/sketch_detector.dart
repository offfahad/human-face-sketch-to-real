// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class SketchDetector {
  final Uint8List imageBytes;
  final int sampleSize;
  final double whiteThreshold;
  final double blackThreshold;

  SketchDetector({
    required this.imageBytes,
    this.sampleSize = 1000,
    this.whiteThreshold = 0.7, // 70% white pixels
    this.blackThreshold = 0.1, // 10% black pixels
  });

  Future<bool> isWhiteBackgroundBlackLinesSketch() async {
    try {
      final image = img.decodeImage(imageBytes)!;
      final colors = _samplePixels(image);
      final dominantColors = _kMeansClustering(colors, k: 2);

      // Check if we have one very light and one very dark color
      final hasWhite = dominantColors.any((color) => _isWhite(color));
      final hasBlack = dominantColors.any((color) => _isBlack(color));

      if (!hasWhite || !hasBlack) return false;

      // Count pixel distribution
      final pixelCounts = _countPixelsByColor(image, dominantColors);
      final totalPixels = image.width * image.height;

      final whitePercentage =
          pixelCounts[_findWhitest(dominantColors)]! / totalPixels;
      final blackPercentage =
          pixelCounts[_findBlackest(dominantColors)]! / totalPixels;

      return whitePercentage >= whiteThreshold &&
          blackPercentage >= blackThreshold;
    } catch (e) {
      debugPrint('Sketch detection error: $e');
      return false;
    }
  }

  List<Color> _samplePixels(img.Image image) {
    final random = Random();
    final colors = <Color>[];
    final pixelCount = image.width * image.height;
    final sampleCount = min(sampleSize, pixelCount);

    for (int i = 0; i < sampleCount; i++) {
      final x = random.nextInt(image.width);
      final y = random.nextInt(image.height);
      final pixel = image.getPixel(x, y);
      colors.add(Color.fromARGB(
          255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
    }

    return colors;
  }

  List<Color> _kMeansClustering(List<Color> colors,
      {int k = 2, int maxIterations = 10}) {
    if (colors.isEmpty) return [];

    // Initialize centroids randomly
    final random = Random();
    var centroids =
        List<Color>.generate(k, (_) => colors[random.nextInt(colors.length)]);

    for (int iteration = 0; iteration < maxIterations; iteration++) {
      // Assign each color to nearest centroid
      final clusters = List<List<Color>>.generate(k, (_) => []);

      for (final color in colors) {
        var nearestIndex = 0;
        var nearestDistance = _colorDistance(color, centroids[0]);

        for (int i = 1; i < k; i++) {
          final distance = _colorDistance(color, centroids[i]);
          if (distance < nearestDistance) {
            nearestDistance = distance;
            nearestIndex = i;
          }
        }
        clusters[nearestIndex].add(color);
      }

      // Update centroids
      final newCentroids = <Color>[];
      for (final cluster in clusters) {
        if (cluster.isEmpty) {
          newCentroids.add(centroids[clusters.indexOf(cluster)]);
          continue;
        }

        var r = 0, g = 0, b = 0;
        for (final color in cluster) {
          r += color.red;
          g += color.green;
          b += color.blue;
        }

        newCentroids.add(Color.fromARGB(
          255,
          (r / cluster.length).round(),
          (g / cluster.length).round(),
          (b / cluster.length).round(),
        ));
      }

      // Check for convergence
      if (_listsEqual(centroids, newCentroids)) break;
      centroids = newCentroids;
    }

    return centroids;
  }

  Map<Color, int> _countPixelsByColor(img.Image image, List<Color> colors) {
    final counts = <Color, int>{};
    for (final color in colors) {
      counts[color] = 0;
    }

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final color = Color.fromARGB(
            255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt());
        final nearestColor = _findNearestColor(color, colors);
        counts[nearestColor] = counts[nearestColor]! + 1;
      }
    }

    return counts;
  }

  Color _findNearestColor(Color target, List<Color> colors) {
    var nearest = colors.first;
    var minDistance = _colorDistance(target, nearest);

    for (final color in colors.skip(1)) {
      final distance = _colorDistance(target, color);
      if (distance < minDistance) {
        minDistance = distance;
        nearest = color;
      }
    }

    return nearest;
  }

  Color _findWhitest(List<Color> colors) {
    return colors.reduce((a, b) =>
        (a.red + a.green + a.blue) > (b.red + b.green + b.blue) ? a : b);
  }

  Color _findBlackest(List<Color> colors) {
    return colors.reduce((a, b) =>
        (a.red + a.green + a.blue) < (b.red + b.green + b.blue) ? a : b);
  }

  bool _isWhite(Color color) {
    return color.red > 200 && color.green > 200 && color.blue > 200;
  }

  bool _isBlack(Color color) {
    return color.red < 55 && color.green < 55 && color.blue < 55;
  }

  double _colorDistance(Color a, Color b) {
    return sqrt(pow(a.red - b.red, 2) +
        pow(a.green - b.green, 2) +
        pow(a.blue - b.blue, 2));
  }

  bool _listsEqual(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
