import 'package:flutter/material.dart';
import '../sizing/sizing_config.dart';
import 'app_color.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: AppColor.lightPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.lightBackground,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColor.lightBackground
    ),
    brightness: Brightness.light,
    dividerColor: AppColor.lightOutlineBorder,
    cardColor: AppColor.lightCardColor,
    canvasColor: AppColor.lightCanvasColor,
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: AppColor.icon,
      size: 20.0,
    ),
    scaffoldBackgroundColor: AppColor.lightBackground,
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        color: AppColor.darkPrimary,
        fontSize: 32.0,
        fontWeight: FontWeight.w900,
      ),
      titleLarge: const TextStyle(
        color: AppColor.darkPrimary,
        fontSize: 32.0,
        fontWeight: FontWeight.w900,
      ),
      titleMedium: TextStyle(
        color: AppColor.darkPrimary,
        fontSize: SizingConfig.textMultiplier * 3.5,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: AppColor.darkPrimary,
        fontSize: SizingConfig.textMultiplier * 2.5,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColor.lightSubTitleText,
        fontSize: SizingConfig.textMultiplier * 1.6,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: AppColor.lightTableRowText,
        fontSize: SizingConfig.textMultiplier * 1.5,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        color: AppColor.lightDescriptionText,
        fontSize: SizingConfig.textMultiplier * 1.4,
        fontWeight: FontWeight.w600,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all<Color>(AppColor.accent),
    ),
    // todo: implement
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.lightBackground
    ),
    dialogTheme: const DialogTheme(

    ),
  );

  static ThemeData dark = ThemeData(
    primaryColor: AppColor.darkPrimary,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.darkBackground,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColor.darkBackground,
    ),
    brightness: Brightness.dark,
    canvasColor: AppColor.darkCanvasColor,
    cardColor: AppColor.darkCardColor,
    //cardColor: AppColor.darkSecondary,
    dividerColor: AppColor.darkOutlineBorder,
    fontFamily: 'Inter',
    iconTheme: const IconThemeData(
      color: AppColor.icon,
      size: 20.0,
    ),
    scaffoldBackgroundColor: AppColor.darkBackground,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColor.lightPrimary,
        fontSize: 32.0,
        fontWeight: FontWeight.w900,
      ),
      titleLarge: TextStyle(
        color: AppColor.lightPrimary,
        fontSize: 32.0,
        fontWeight: FontWeight.w900,
      ),
      titleMedium: TextStyle(
        color: AppColor.lightPrimary,
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: TextStyle(
        color: AppColor.darkSubTitleText,
        fontSize: 12.0,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(
        color: AppColor.darkTableColumnText,
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: AppColor.darkTableRowText,
        fontSize: 11.0,
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        color: AppColor.darkDescriptionText,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all<Color>(AppColor.accent),
    ),
    // todo: implement
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColor.darkBackground,
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ),
    checkboxTheme: const CheckboxThemeData(side: BorderSide(color: AppColor.darkOutline, width: 1.5,),),
  );
}