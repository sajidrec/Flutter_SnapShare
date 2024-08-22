import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/controller/auth_controller/registration_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/selected_image_name_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/upload_user_info_db_controller.dart';
import 'package:snapshare/presentation/screens/auth/login_screen.dart';
import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
import 'package:snapshare/utils/app_colors.dart';
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
  final TextEditingController nameTeController = TextEditingController();
  final TextEditingController usernameTeController = TextEditingController();
  late bool _savePassword = false;
  bool _passwordValid = false;

  XFile? profileImage;

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
      body: GetBuilder<RegistrationController>(builder: (
        registrationController,
      ) {
        return registrationController.inProgress
            ? const Center(
                child: CupertinoActivityIndicator(
                  color: AppColor.themeColor,
                ),
              )
            : SingleChildScrollView(
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
                              'Enter your details',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            GetBuilder<SelectedImageNameController>(
                                builder: (selectedImageNameController) {
                              return Text(
                                selectedImageNameController.pickedImageName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              );
                            }),
                            const SizedBox(height: 10),
                            GetBuilder<SelectedImageNameController>(
                                builder: (selectedImageNameController) {
                              return _buildSelectPicture(
                                onTapFunc: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  profileImage = await imagePicker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  selectedImageNameController.provideFileName(
                                    pickedImage: profileImage,
                                  );
                                },
                              );
                            }),
                            const SizedBox(height: 10),
                            const Text(
                              'Username',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            TextFields(
                              hintText: "Only lowercase letter allowed",
                              controller: usernameTeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Can't be empty";
                                } else if (RegExp(r'^[a-z]+$')
                                    .hasMatch(value)) {
                                  return null;
                                }

                                return "Enter valid username";
                              },
                              icon: const Icon(Icons.person_outline),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Full Name',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            TextFields(
                              hintText: "Your name",
                              controller: nameTeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your name";
                                }
                                return null;
                              },
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 10),
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
                            const Text('Passwords',
                                style: TextStyle(fontSize: 16)),
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
                                if (value == null ||
                                    value != passwordController.text) {
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
                              child: GetBuilder<UploadUserInfoDbController>(
                                  builder: (uploadUserInfoDbController) {
                                return ElevatedButton(
                                  onPressed: _passwordValid != false
                                      ? () async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());

                                          bool userInfoUploaded =
                                              await uploadUserInfoDbController
                                                  .uploadUserInfo(
                                            username: usernameTeController.text
                                                .trim(),
                                            userFullName:
                                                nameTeController.text.trim(),
                                            userEmail:
                                                emailController.text.trim(),
                                            uid: '',
                                          );
                                          // uid needed

                                          if (!userInfoUploaded) {
                                            usernameTeController.text = "";
                                            Get.snackbar(
                                              "Failed",
                                              "try different username",
                                            );
                                          }

                                          if (profileImage == null) {
                                            Get.snackbar(
                                              "Select profile picture",
                                              "",
                                            );
                                          }

                                          if ((_formKey.currentState
                                                      ?.validate() ??
                                                  false) &&
                                              profileImage != null) {
                                            bool registrationStatus =
                                                await registrationController
                                                    .registerNewUser(
                                              userFullName:
                                                  nameTeController.text.trim(),
                                              profilePicturePath:
                                                  profileImage!.path,
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text,
                                              userName: usernameTeController
                                                  .text
                                                  .trim(),
                                            );

                                            if (registrationStatus) {
                                              if (mounted) {
                                                Get.snackbar(
                                                  "Sucess",
                                                  "Registration successful please login",
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                );
                                                Get.offAll(
                                                  () => const LoginScreen(),
                                                );
                                              }
                                            } else {
                                              Get.snackbar(
                                                "Failed",
                                                registrationController
                                                    .errorMessage,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white,
                                              );
                                            }
                                          }
                                        }
                                      : null,
                                  child: const Text('Sign Up'),
                                );
                              }),
                            ),
                            const SizedBox(height: 10),
                            _buildTextButton()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  InkWell _buildSelectPicture({
    required Callback onTapFunc,
  }) {
    return InkWell(
      onTap: onTapFunc,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            width: Get.width / 3,
            height: 40,
            child: const Center(
              child: Text(
                "Select Profile Picture",
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ),
        ],
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
          onPressed: () {
            Get.offAll(const LoginScreen());
          },
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
    super.dispose();
    nameTeController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameTeController.dispose();
  }
}
