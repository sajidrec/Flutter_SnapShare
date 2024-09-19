// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snapshare/controller_binder.dart';
// import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
// import 'package:snapshare/presentation/screens/bottom_nav_bar.dart';
// import 'package:snapshare/utils/app_colors.dart';
//
// class SnapShare extends StatelessWidget {
//   const SnapShare({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialBinding: ControllerBinder(),
//       home: _moveToNextScreen(),
//       theme: _buildThemeData(),
//     );
//   }
//
//   Widget _moveToNextScreen() {
//     if (FirebaseAuth.instance.currentUser?.email != null) {
//       return const BottomNavBar();
//     }
//     return const SignupOrLoginScreen();
//   }
//
//   ThemeData _buildThemeData() {
//     return ThemeData(
//       fontFamily: "Satoshi",
//       scaffoldBackgroundColor: Colors.white,
//       appBarTheme: _buildAppbarTheme(),
//       inputDecorationTheme: _buildInputDecorationTheme(),
//       elevatedButtonTheme: _buildElevatedButtonThemeData(),
//       bottomNavigationBarTheme: _buildBottomNavBarThemeData(),
//     );
//   }
//
//   AppBarTheme _buildAppbarTheme() {
//     return const AppBarTheme(
//       backgroundColor: Colors.white,
//     );
//   }
//
//   ElevatedButtonThemeData _buildElevatedButtonThemeData() {
//     return ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           backgroundColor: AppColor.themeColor,
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
//     );
//   }
//
//   InputDecorationTheme _buildInputDecorationTheme() {
//     return InputDecorationTheme(
//       fillColor: Colors.transparent,
//       filled: true,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//       border: OutlineInputBorder(
//         borderSide: BorderSide.none,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: BorderSide(
//           color: Colors.grey.shade500,
//           width: 1.5,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: AppColor.inputBorderColor,
//           width: 1.5,
//         ),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: AppColor.inputBorderColor,
//           width: 1.5,
//         ),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8),
//         borderSide: const BorderSide(
//           color: Colors.red,
//           width: 1.5,
//         ),
//       ),
//     );
//   }
//
//   BottomNavigationBarThemeData _buildBottomNavBarThemeData() {
//     return const BottomNavigationBarThemeData(
//       selectedIconTheme: IconThemeData(color: AppColor.themeColor),
//       backgroundColor: Colors.white,
//       selectedItemColor: AppColor.themeColor,
//       unselectedItemColor: Colors.black87,
//       showSelectedLabels: false,
//       showUnselectedLabels: false,
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/controller_binder.dart';
import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
import 'package:snapshare/presentation/screens/bottom_nav_bar.dart';
import 'package:snapshare/utils/app_colors.dart';

class SnapShare extends StatelessWidget {
  const SnapShare({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: ControllerBinder(),
      home: _moveToNextScreen(),
      theme: _buildLightThemeData(),
      darkTheme: _buildDarkThemeData(),
      themeMode: ThemeMode.system,
    );
  }

  Widget _moveToNextScreen() {
    if (FirebaseAuth.instance.currentUser?.email != null) {
      return const BottomNavBar();
    }
    return const SignupOrLoginScreen();
  }

  ThemeData _buildLightThemeData() {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: "Satoshi",
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: _buildAppbarTheme(Colors.white),
      inputDecorationTheme: _buildInputDecorationTheme(
          Colors.grey.shade500, AppColor.inputBorderColor),
      elevatedButtonTheme: _buildElevatedButtonThemeData(),
      bottomNavigationBarTheme:
          _buildBottomNavBarThemeData(AppColor.themeColor, Colors.black87),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: Brightness.light,
        primary: Colors.white,
        secondary: Colors.white,
      ),
    );
  }

  ThemeData _buildDarkThemeData() {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: "Satoshi",
      scaffoldBackgroundColor: Colors.white10,
      appBarTheme: _buildAppbarTheme(Colors.white10),
      inputDecorationTheme:
          _buildInputDecorationTheme(Colors.black54, Colors.blueGrey),
      elevatedButtonTheme: _buildElevatedButtonThemeData(),
      bottomNavigationBarTheme:
          _buildBottomNavBarThemeData(AppColor.themeColor, Colors.white),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: Brightness.dark,
        primary: Colors.grey.shade800,
        secondary: Colors.white60,
      ),
    );
  }

  AppBarTheme _buildAppbarTheme(Color backgroundColor) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme(
    Color enabledBorderColor,
    Color focusedBorderColor,
  ) {
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
          color: enabledBorderColor,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  BottomNavigationBarThemeData _buildBottomNavBarThemeData(
      Color selectedItemColor, Color unselectedItemColor) {
    return BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: selectedItemColor),
      backgroundColor: Colors.transparent,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}

class ThemeService {
  final _themeMode = ThemeMode.light.obs;

  ThemeMode get theme => _themeMode.value;

  void switchTheme() {
    if (_themeMode.value == ThemeMode.light) {
      _themeMode.value = ThemeMode.dark;
    } else {
      _themeMode.value = ThemeMode.light;
    }
  }
}
