import 'package:flutter/material.dart';

class TElevatedButton{
  TElevatedButton._();
  static final lightElevatedButton = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 3,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0x814BC71A),
          side: const BorderSide(color: Color(0xFF2D402D),width: 1),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: Size(20, 20),
          shadowColor: Colors.grey.withOpacity(0.3)
      )
  );
  static final drkElevatedButton = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          elevation: 8,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF2D402D),
          side: const BorderSide(color: Color(0x814BC71A),width: 1),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          minimumSize: Size(20, 20),
          shadowColor: Colors.grey.withOpacity(0.3)
      )
  );
}
