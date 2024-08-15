import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
import 'package:snapshare/presentation/screens/bottom_nav_bar.dart';
import 'package:snapshare/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  late bool _savePassword = false;
  bool _passwordValid = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validatePassword);
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      'Enter your phone number and password',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const Text('Email', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    TextFields(
                      hintText: 'Email',
                      icon: const Icon(Icons.email_outlined),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Passwords', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    TextFields(
                      hintText: 'Passwords',
                      icon: const Icon(Icons.lock_outline),
                      isPassword: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('Confirm Passwords',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    TextFields(
                      hintText: 'Confirm Passwords',
                      icon: const Icon(Icons.lock_outline),
                      isPassword: true,
                      controller: confirmPasswordController,
                      validator: (value) {
                        if (value == null || value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildCheckBox(_savePassword),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _passwordValid != false
                              ? () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    Get.offAll(() => const BottomNavBar());
                                  }
                                }
                              : null,
                          child: const Text('Sign Up')),
                    ),
                    const SizedBox(height: 10),
                    _buildTextButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validatePassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    setState(() {
      _passwordValid = password.length >= 6 && confirmPassword.length >= 6;
    });
  }

  Widget _buildCheckBox(bool savePassword) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {});
            _savePassword = !_savePassword;
          },
          child: Row(
            children: [
              Checkbox(
                value: _savePassword,
                onChanged: (bool? value) {
                  setState(() {});
                  _savePassword = value ?? false;
                },
              ),
              const Text(
                'Save Password',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.blueGrey),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Log In',
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
