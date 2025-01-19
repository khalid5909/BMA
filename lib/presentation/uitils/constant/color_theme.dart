import 'package:flutter/material.dart';

class TColors{

  TColors._();
  //primary color
  static const Color prymary = Colors.white;
  static const Color secondary = Color(0xFFBBDEFB);
  static const Color accent = Color(0xFFBBDEFB);
  //dark light color
  static const Color light = Colors.white;
  static const Color dark = Colors.black;
  static const Color primaryBackground = Colors.white;
  //text color
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.black;
  static const Color textWhite = Colors.blue;
  //container color
  //static const Color lightContainer = Color(0xfff6f6f6);
  //static Color darkContainer = TColors.light.withOpacity(0.1);
  //gradiyent color
  static const Gradient linearGradientPink = LinearGradient(begin: Alignment.topLeft,colors: [
    Color(0xff03082a),
    Color(0xffad1457),
    Color(0xfff06292)]
  );
  static const Gradient linearGradientPurple = LinearGradient(begin: Alignment.bottomLeft,colors: [
    Color(0xFFF3E5F5),
    Color(0xFFE1BEE7),
    Color(0xFFCE93D8)]
  );
}

