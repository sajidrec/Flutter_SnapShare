import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/models/story_models.dart';
import 'package:snapshare/presentation/screens/day_story_screen.dart';
import 'package:uuid/uuid.dart';

class StoryController extends GetxController {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth fAuth = FirebaseAuth.instance;

  var storyPosts = <StoryModels>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> createStoryPost({
    required String imageUrl,
    required String caption,
    required List<String> locations,
  }) async {
    String postId = const Uuid().v4();
    User? currentUser = fAuth.currentUser;

    if (currentUser == null) {
      Get.snackbar('Error', 'No user is currently signed in');
      return;
    }

    await Get.find<GetUserinfoByEmailController>()
        .fetchUserData(email: FirebaseAuth.instance.currentUser?.email ?? "");

    final currentUserInfo =
        await Get.find<GetUserinfoByEmailController>().getUserData;

    try {
      await fireStore.collection('storyPost').doc(postId).set({
        'imageUrl': imageUrl,
        'caption': caption,
        'locations': locations,
        'userId': currentUser.uid,
        'postId': postId,
        'likes': [],
        'comments': [],
        'timestamp': FieldValue.serverTimestamp(),
        'userFullName': currentUser.displayName,
        'userProfilePic': currentUser.photoURL,
        'username': currentUserInfo["username"],
      });

      await Get.find<GetUserinfoByEmailController>()
          .fetchUserData(email: FirebaseAuth.instance.currentUser?.email ?? "");

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore
          .collection("userInfo")
          .doc(await Get.find<GetUserinfoByEmailController>()
              .getUserData["username"])
          .update({
        "storyPost": FieldValue.arrayUnion(
          [
            postId,
          ],
        ),
      });
      Get.back();
      Get.snackbar('Success', 'Post created successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> pickImageForStory(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: source);

    if (image != null) {
      final File imageFile = File(image.path);
      final String? uploadedImageUrl = await uploadStoryImage(imageFile);

      if (uploadedImageUrl != null) {
        Get.to(() => StoryPostScreen(imagePath: image.path));
      }
    }
  }

  Future<String?> uploadStoryImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
            'storyImages/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );

      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  Future<void> fetchPosts() async {
    try {
      final now = DateTime.now();
      final twentyFourHoursAgo = now.subtract(const Duration(minutes: 20));

      final snapshot = await FirebaseFirestore.instance
          .collection('storyPost')
          .where('timestamp', isGreaterThan: twentyFourHoursAgo)
          .orderBy('timestamp', descending: true)
          .get();

      final fetchedPosts =
          snapshot.docs.map((doc) => StoryModels.fromDocument(doc)).toList();
      storyPosts.assignAll(fetchedPosts);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch posts: $e');
    }
  }

  void refreshPosts() {
    fetchPosts();
  }
}
