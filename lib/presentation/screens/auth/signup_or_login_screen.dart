import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/screens/auth/login_screen.dart';
import 'package:snapshare/presentation/screens/auth/signup_screen.dart';
import 'package:snapshare/utils/app_colors.dart';

class SignupOrLoginScreen extends StatefulWidget {
  const SignupOrLoginScreen({super.key});

  @override
  State<SignupOrLoginScreen> createState() => _SignupOrLoginScreenState();
}

class _SignupOrLoginScreenState extends State<SignupOrLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final customColor = AppColor.lightOrDark(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width / 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeaderLogo(customColor),
              const SizedBox(height: 22),
              _buildCreateAccountButton(),
              const SizedBox(height: 14),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderLogo(Color color) {
    return Text(
      "SnapShare",
      style: TextStyle(
          fontFamily: "Lobster",
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: color),
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          Get.to(
            const SignupScreen(),
          );
        },
        child: const Text(
          "Create Account",
          style: TextStyle(
            fontFamily: "Satoshi",
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () {
        Get.to(
          const LoginScreen(),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Log In",
            style: TextStyle(
              fontFamily: "Satoshi",
              fontWeight: FontWeight.w700,
              color: AppColor.themeColor,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.themeColor,
          ),
        ],
      ),
    );
  }
}
