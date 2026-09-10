import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoxo/ui/themes/colors.dart';

abstract final class AppTheme{
  static const  _textTheme=TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,fontWeight: .w500
    ),
    
  );
   static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.blue2,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  ); 
  static ThemeData lightTheme=ThemeData(
    brightness: .light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _textTheme,
    inputDecorationTheme: _inputDecorationTheme,
    fontFamily: GoogleFonts.monaSans().fontFamily
  );
}