import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UpdateProfileController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<bool> updateUserProfile({
    required String? userName,
    String? profilePicturePath,
    String? password,
  }) async {
    _inProgress = true;
    update();

    try {
      FirebaseAuth fAuth = FirebaseAuth.instance;
      User? currentUser = fAuth.currentUser;

      if (currentUser == null) {
        _inProgress = false;
        _errorMessage = "No user is currently signed in";
        update();
        return false;
      }

      // Update display name if provided
      if (userName != null && userName.isNotEmpty) {
        await currentUser.updateDisplayName(userName);
      }

      // Upload and update profile picture if path is provided
      if (profilePicturePath != null && profilePicturePath.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileImageRef =
        storageRef.child("userProfilePictures/${currentUser.uid}");
        File imageFile = File(profilePicturePath);
        await profileImageRef.putFile(imageFile);

        String photoURL = await profileImageRef.getDownloadURL();
        await currentUser.updatePhotoURL(photoURL);
      }

      // Update password if provided
      if (password != null && password.isNotEmpty) {
        await currentUser.updatePassword(password);
      }

      _inProgress = false;
      update();
      return true;
    } on FirebaseAuthException catch (e) {
      _inProgress = false;
      _errorMessage = e.message ?? "Unknown error occurred";
      update();
      return false;
    }
  }
}
