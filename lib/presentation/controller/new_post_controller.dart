import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/screens/new_post_screen.dart';

import 'get_post_info_controller.dart';

class NewPostController extends GetxController {
  Future<void> createPost({
    required String imageUrl,
    required String caption,
    required List<String> locations,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth fAuth = FirebaseAuth.instance;
    User? currentUser = fAuth.currentUser;

    if (currentUser == null) {
      Get.snackbar('Error', 'No user is currently signed in');
      return;
    }

    try {
      await firestore.collection('posts').add({
        'imageUrl': imageUrl,
        'caption': caption,
        'locations': locations,
        'userId': currentUser.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Get.back();
      Get.snackbar('Success', 'Post created successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> pickImageForBottomNav(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: source);
    if (image != null) {
      String? uploadedImageUrl =
          await uploadImageForBottomNav(File(image.path));
      if (uploadedImageUrl != null) {
        Get.to(() => NewPostScreen(imagePath: image.path));
      }
    }
  }

  Future<String?> uploadImageForBottomNav(File imageFile) async {
    GetPostInfoController postController = Get.put(GetPostInfoController());
    String? imageUrl = await postController.uploadPostImage(imageFile);
    return imageUrl;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child(
        'postImages/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await imageRef.putFile(imageFile);
      String downloadURL = await imageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }
}
