import 'package:flutter/material.dart';
import 'package:snapshare/widgets/check_box.dart';
import 'package:snapshare/widgets/text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back_ios_new),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              const Text(
                "Enter your phone number\nand password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 32),
              const Text('Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              TextFields(
                  hintText: 'Email',
                  icon: const Icon(Icons.email_outlined),
                  controller: emailController),
              const SizedBox(height: 15),
              const Text('Password',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              TextFields(
                  isPassword: true,
                  hintText: 'Password',
                  icon: const Icon(Icons.lock_open_outlined),
                  controller: emailController),
              const SizedBox(height: 10),
              const CheckBox(),
              const SizedBox(height: 18),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(onPressed: () {}, child: const Text("Login")))
            ],
          ),
        ),
      ),
    );
  }
}
