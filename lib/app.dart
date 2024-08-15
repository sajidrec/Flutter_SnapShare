import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
import 'package:snapshare/utils/app_colors.dart';

class SnapShare extends StatelessWidget {
  const SnapShare({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SignupOrLoginScreen(),
      theme: _buildThemeData(),
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: _buildAppbarTheme(),
      inputDecorationTheme: _buildInputDecorationTheme(),
      elevatedButtonTheme: _buildElevatedButtonThemeData(),
      bottomNavigationBarTheme: _buildBottomNavBarThemeData(),
    );
  }

  AppBarTheme _buildAppbarTheme() {
    return const AppBarTheme(
      backgroundColor: Colors.white,
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: AppColor.themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme() {
    return InputDecorationTheme(
      fillColor: Colors.transparent,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: Colors.grey.shade500,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColor.inputBorderColor,
          width: 1.5,
        ),
      ),
    );
  }

  BottomNavigationBarThemeData _buildBottomNavBarThemeData() {
    return const BottomNavigationBarThemeData(
      selectedIconTheme: const IconThemeData(color: AppColor.themeColor),
      backgroundColor: Colors.white,
      selectedItemColor: AppColor.themeColor,
      unselectedItemColor: Colors.black87,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
