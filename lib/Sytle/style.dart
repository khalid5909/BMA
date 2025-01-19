import 'package:flutter/material.dart';

class TInputDecoration {
  TInputDecoration._();

  static InputDecorationTheme light = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    labelStyle: TextStyle(color: Color(0xFF81C784)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),
  );
  static InputDecorationTheme dark = InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1F22),
    labelStyle: TextStyle(color: Color(0xFF81C784)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.green, width: 2),
    ),);
}

SizedBox TSizeBox(child){
  return SizedBox(
    height: 200,
    width: double.infinity,
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: child,
    ),
  );
}

