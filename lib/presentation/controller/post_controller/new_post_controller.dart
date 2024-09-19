import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/models/post_models.dart';
import 'package:snapshare/presentation/screens/new_post_screen.dart';
import 'package:uuid/uuid.dart';

import 'get_post_info_controller.dart';

class NewPostController extends GetxController {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  final GetPostInfoController postController =
      Get.find<GetPostInfoController>();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  var posts = <Post>[].obs;

  Future<void> createPost({
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
      await fireStore.collection('posts').doc(postId).set({
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
        "posts": FieldValue.arrayUnion(
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

  Future<void> pickImageForBottomNav(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(source: source);

    if (image != null) {
      final File imageFile = File(image.path);
      final String? uploadedImageUrl = await uploadImage(imageFile);

      if (uploadedImageUrl != null) {
        Get.to(() => NewPostScreen(imagePath: image.path));
      }
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
            'postImages/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );

      await storageRef.putFile(imageFile);
      return await storageRef.getDownloadURL();
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  Future<void> toggleLike(String postId) async {
    User? currentUser = fAuth.currentUser;

    if (currentUser == null) {
      Get.snackbar('Error', 'No user is currently signed in');
      return;
    }

    final DocumentReference postRef = fireStore.collection('posts').doc(postId);

    await fireStore.runTransaction((transaction) async {
      final DocumentSnapshot postSnapshot = await transaction.get(postRef);
      final List<dynamic> likes = postSnapshot.get('likes') as List<dynamic>;

      if (likes.contains(currentUser.uid)) {
        transaction.update(postRef, {
          'likes': FieldValue.arrayRemove([currentUser.uid]),
        });
      } else {
        transaction.update(postRef, {
          'likes': FieldValue.arrayUnion([currentUser.uid]),
        });
      }
    });
    update();
  }

  void fetchPosts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      final fetchedPosts =
          snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
      posts.assignAll(fetchedPosts);
    } catch (e) {
      throw e.toString();
    }
  }
}
