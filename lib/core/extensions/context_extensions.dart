import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get topPaddingRaw => MediaQuery.of(this).padding.top;
  double get bottomPaddingRaw => MediaQuery.of(this).padding.bottom;
  double get topPadding =>
      MediaQuery.of(this).padding.top > 0
          ? MediaQuery.of(this).padding.top
          : 15;
  double get bottomPadding =>
      MediaQuery.of(this).padding.bottom > 0
          ? MediaQuery.of(this).padding.bottom
          : 20;

  double responsiveFontSize(double fontSize, {double? min, double? max}) {
    const referenceWidth = 430.0;
    final screenWidth = MediaQuery.of(this).size.width;

    final double minSize = min ?? (fontSize);
    final double maxSize = max ?? (fontSize + 4);

    double scaledSize = fontSize * (screenWidth / referenceWidth);

    return scaledSize.clamp(minSize, maxSize);
  }

  double responsiveSize(double size, {double? min, double? max}) {
    const referenceWidth = 430.0;
    final screenWidth = MediaQuery.of(this).size.width;

    final double minSize = min ?? (size - 4);
    final double maxSize = max ?? (size + 10);

    double scaledSize = size * (screenWidth / referenceWidth);

    return scaledSize.clamp(minSize, maxSize);
  }
}
