import 'package:flutter/material.dart';
import 'package:snapshare/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Inter your phone number and password',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20),
              const Text('Email', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextFields(
                hintText: 'Email',
                icon: const Icon(Icons.email_outlined),
                controller: emailController,
              ),
              const SizedBox(height: 10),
              const Text('Passwords', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextFields(
                hintText: 'Passwords',
                icon: const Icon(Icons.lock_outline),
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              const Text('Confirm Passwords', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              TextFields(
                hintText: 'Confirm Passwords',
                icon: const Icon(Icons.lock_outline),
                isPassword: true,
                controller: confirmPasswordController,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Sign Up')),
              ),
              const SizedBox(height: 10),
              Row(
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
                    onPressed: () {},
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  )
                ],
              )
            ]),
      ),
    );
  }
}
