import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111111);
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF8E1618);
  static const Color accent = Color(0xFFC21F20);
  static const Color correct = Color(0xFF4BDE50);

  // gradients

  static List<Color> onboardingGradientColors = [
    Color(0xff2C0000),
    Color(0xff140000),
  ];

  static LinearGradient onboardingGradient({
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
  }) => LinearGradient(
    colors: onboardingGradientColors,
    begin: begin,
    end: end,
  );

  static List<Color> proGradientColors = [
    Color(0xffF24A33),
    Color(0xffEE8C8C),
  ];

  static LinearGradient proGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
  }) => LinearGradient(
    colors: proGradientColors,
    begin: begin,
    end: end,
  );
}
