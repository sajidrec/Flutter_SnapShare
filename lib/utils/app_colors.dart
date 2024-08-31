import 'package:flutter/material.dart';

class AppColor {
  static const Color themeColor = Color(0xFF4478FF);
  static const Color inputBorderColor = Color(0xFF6993FF);

  static Color lightOrDark(context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white : Colors.black;
    return color;
  }

  static Color isItDark(context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.black : Colors.white;
    return color;
  }

  static Color forBottomNav(context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.black38 : Colors.white;
    return color;
  }

  static Color forText(context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final color = isDarkMode ? Colors.white70 : Colors.black;
    return color;
  }
}
