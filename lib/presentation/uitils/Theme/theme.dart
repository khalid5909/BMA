import 'package:bachelor_meal_asistance/Sytle/style.dart';
import 'package:bachelor_meal_asistance/presentation/uitils/Theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'appBar.dart';
import 'button_theme_data.dart';

class AppTheme{
  AppTheme._();
  static ThemeData lighttheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFFBBDEFB),
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButton.lightElevatedButton,
    appBarTheme: TTabTheme.LightAppBarTheme,
    inputDecorationTheme: TInputDecoration.light
  );
  static ThemeData darktheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'poppins',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1E1F22),
      primaryColor: Colors.blue,
      textTheme: TTextTheme.darkTextTheme,
      elevatedButtonTheme: TElevatedButton.drkElevatedButton,
      appBarTheme: TTabTheme.DarkAppBarTheme,
      inputDecorationTheme: TInputDecoration.dark
  );
}
