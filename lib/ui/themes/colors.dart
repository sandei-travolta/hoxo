import 'package:flutter/material.dart';

abstract final class AppColors{
  static const primary=Colors.white;
  static const onPrimary=Colors.black12;
  static const secondary=Color(0xFF0AB9F3);
  static const onSecondary=Colors.red;
  static const error=Colors.white;
  static const onError=Colors.red;
  static const blue1=Color(0xFF01491BB);
  static const blue2=Color(0xFF074053);
  
  static const lightColorScheme=ColorScheme(
    brightness: .light, 
    primary: primary, 
    onPrimary: onPrimary, 
    secondary: secondary, 
    onSecondary: onSecondary, 
    error: error, 
    onError: onError, 
    surface: Colors.white, 
    onSurface: Colors.black
    );
}