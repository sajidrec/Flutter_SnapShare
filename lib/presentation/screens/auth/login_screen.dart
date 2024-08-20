import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/auth_controller/login_controller.dart';
import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
import 'package:snapshare/presentation/screens/auth/signup_screen.dart';
import 'package:snapshare/presentation/screens/bottom_nav_bar.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/widgets/check_box.dart';
import 'package:snapshare/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    passwordController.addListener(() {
      final isButtonActive = passwordController.text.isNotEmpty;
      setState(() {
        this.isButtonActive = isButtonActive;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const SignupOrLoginScreen());
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: GetBuilder<LoginController>(builder: (loginController) {
          return loginController.inProgress
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.themeColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 64),
                      const Text(
                        "Enter your phone number\nand password",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 32),
                      const Text('Email',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      TextFields(
                          hintText: 'Email',
                          icon: const Icon(Icons.email_outlined),
                          controller: emailController),
                      const SizedBox(height: 15),
                      const Text('Password',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 10),
                      TextFields(
                        isPassword: true,
                        hintText: 'Password',
                        icon: const Icon(Icons.lock_open_outlined),
                        controller: passwordController,
                      ),
                      const SizedBox(height: 10),
                      const CheckBox(),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            bool loginStatus = await loginController.userLogin(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );

                            if (loginStatus) {
                              Get.snackbar(
                                "Login Success",
                                "Welcome back",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Get.offAll(
                                const BottomNavBar(),
                              );
                            } else {
                              Get.snackbar(
                                "Login Failed",
                                loginController.errorMsg,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text("Login"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextButton()
                    ],
                  ),
                );
        }),
      ),
    );
  }

  Widget _buildTextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.blueGrey),
        ),
        TextButton(
          onPressed: () {
            Get.to(() => const SignupScreen());
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
