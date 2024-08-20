import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/controller/auth_controller/selected_image_name_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/update_profile_controller.dart';
import 'package:snapshare/presentation/screens/profile_screen.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/widgets/text_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameTeController = TextEditingController();
  bool _savePassword = false;

  XFile? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const ProfileScreen());
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: GetBuilder<UpdateProfileController>(
          builder: (updateProfileController) {
        return updateProfileController.inProgress
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
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            const Text(
                              'Update your details',
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 10),
                            GetBuilder<SelectedImageNameController>(
                                builder: (selectedImageNameController) {
                              return Text(
                                selectedImageNameController.pickedImageName ??
                                    '',
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
                                  if (profileImage != null) {
                                    selectedImageNameController.provideFileName(
                                      pickedImage: profileImage,
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Error",
                                      "No image selected",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                              );
                            }),
                            const SizedBox(height: 10),
                            const Text('Full Name',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            TextFields(
                              hintText: "Your name",
                              controller: nameTeController,
                              icon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 10),
                            const Text('Email', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            TextFields(
                              hintText: 'Email',
                              icon: const Icon(Icons.email_outlined),
                              controller: emailController,
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
                            ),
                            const SizedBox(height: 10),
                            _buildCheckBox(),
                            const SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();

                                  if (profileImage == null) {
                                    Get.snackbar(
                                      "Select profile picture",
                                      "Please select a profile picture before updating.",
                                    );
                                    return;
                                  }

                                  if (profileImage != null) {
                                    bool updateStatus =
                                        await updateProfileController
                                            .updateUserProfile(
                                      userName: nameTeController.text.trim(),
                                      profilePicturePath: profileImage!.path,
                                      email: emailController.text.trim(),
                                      password: passwordController.text,
                                    );

                                    if (updateStatus) {
                                      Get.snackbar(
                                        "Success",
                                        "Profile updated successfully",
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                      );Get.to(()=>const ProfileScreen());
                                    } else {
                                      Get.snackbar(
                                        "Failed",
                                        updateProfileController.errorMessage,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  }
                                },
                                child: const Text('Update Profile'),
                              ),
                            ),
                            const SizedBox(height: 10),
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

  InkWell _buildSelectPicture({required void Function() onTapFunc}) {
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
                "Update Profile Picture",
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

  Widget _buildCheckBox() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _savePassword = !_savePassword;
            });
          },
          child: Row(
            children: [
              Checkbox(
                value: _savePassword,
                onChanged: (bool? value) {
                  setState(() {
                    _savePassword = value ?? false;
                  });
                },
              ),
              const Text("Save Password"),
            ],
          ),
        ),
      ],
    );
  }
}
