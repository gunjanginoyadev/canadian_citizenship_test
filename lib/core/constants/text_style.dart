import 'package:canadian_citizenship/libs.dart';

TextStyle light(
  BuildContext context, {
  double fontSize = 20,
  double? min,
  double? max,
  double? height,
  Color? color,
  String? fontFamily,
}) => TextStyle(
  fontSize: context.responsiveFontSize(fontSize, min: min, max: max),
  fontWeight: FontWeight.w300,
  color: color ?? AppColors.black,
  fontFamily: fontFamily,
);

TextStyle regular(
  BuildContext context, {
  double fontSize = 20,
  double? min,
  double? max,
  double? height,
  Color? color,
  String? fontFamily,
}) => TextStyle(
  fontSize: context.responsiveFontSize(fontSize, min: min, max: max),
  fontWeight: FontWeight.normal,
  color: color ?? AppColors.black,
  fontFamily: fontFamily,
);

TextStyle medium(
  BuildContext context, {
  double fontSize = 20,
  double? min,
  double? max,
  double? height,
  Color? color,
  String? fontFamily,
}) => TextStyle(
  fontSize: context.responsiveFontSize(fontSize, min: min, max: max),
  fontWeight: FontWeight.w500,
  color: color ?? AppColors.black,
  fontFamily: fontFamily,
);

TextStyle semiBold(
  BuildContext context, {
  double fontSize = 20,
  double? min,
  double? max,
  double? height,
  Color? color,
  String? fontFamily,
}) => TextStyle(
  fontSize: context.responsiveFontSize(fontSize, min: min, max: max),
  fontWeight: FontWeight.w600,
  color: color ?? AppColors.black,
  fontFamily: fontFamily,
);

TextStyle bold(
  BuildContext context, {
  double fontSize = 20,
  double? min,
  double? max,
  double? height,
  Color? color,
  String? fontFamily,
}) => TextStyle(
  fontSize: context.responsiveFontSize(fontSize, min: min, max: max),
  fontWeight: FontWeight.w700,
  color: color ?? AppColors.black,
  fontFamily: fontFamily,
);
