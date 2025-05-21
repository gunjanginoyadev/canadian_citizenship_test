import 'package:canadian_citizenship/libs.dart';

class AppTheme{
  AppTheme._();

  static  ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.primary,
    fontFamily: "Poppins",
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    )
  );
}