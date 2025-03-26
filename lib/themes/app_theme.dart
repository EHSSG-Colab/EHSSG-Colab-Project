import 'package:flutter/material.dart';

class AppTheme {
  TextStyle displayLarge() {
    return const TextStyle(fontFamily: 'Urbanist', fontSize: 32);
  }

  TextStyle labelMedium() {
    return const TextStyle(fontFamily: 'Urbanist', fontSize: 15);
  }

  TextStyle labelLarge() {
    return const TextStyle(fontFamily: 'Urbanist', fontSize: 20);
  }

  TextStyle buttonLabel() {
    return const TextStyle(
      fontFamily: 'Urbanist',
      fontSize: 15,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.8,
    );
  }

  // colors
  Color primaryColor() {
    return const Color.fromARGB(255, 87, 9, 255);
  }

  Color secondaryColor() {
    return const Color.fromARGB(255, 75, 152, 108);
  }

  Color secondaryDarkColor() {
    return const Color.fromARGB(255, 58, 121, 85);
  }

  Color highlightColor() {
    return const Color.fromARGB(171, 40, 0, 115);
  }

  Color backgroundColor() {
    return const Color.fromARGB(255, 248, 248, 248);
  }

  Color accentColor() {
    return const Color.fromARGB(255, 215, 204, 255);
  }

  Color transparentColor() {
    return const Color.fromARGB(0, 255, 255, 255);
  }

  Color rosyColor() {
    return const Color.fromARGB(255, 255, 58, 58);
  }

  Color primaryLightColor() {
    return const Color.fromARGB(255, 239, 235, 255);
  }

  Color focusedColor() {
    return const Color.fromARGB(255, 84, 22, 255);
  }

  Color grayShadowColor() {
    return const Color.fromARGB(41, 103, 103, 103);
  }

  Color grayTextColor() {
    return const Color.fromARGB(255, 82, 82, 82);
  }

  Color ehssgOrangeColor() {
    return const Color.fromARGB(255, 255, 178, 84);
  }

  OutlineInputBorder normalOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme().transparentColor(), width: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  OutlineInputBorder focusedOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme().focusedColor(), width: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  OutlineInputBorder errorOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppTheme().rosyColor(), width: 2),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static double appBarHeight() {
    return kToolbarHeight;
  }

  disabledTextColor() {}
}
