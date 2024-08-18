import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<bool> registerNewUser({
    required String email,
    required String password,
    required String userName,
    required String profilePicturePath,
  }) async {
    _inProgress = true;
    update();
    try {
      FirebaseAuth fAuth = FirebaseAuth.instance;
      await fAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await fAuth.currentUser?.updateDisplayName(userName);

      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef =
          storageRef.child("userProfilePictures/${fAuth.currentUser?.uid}");
      File imageFile = File(profilePicturePath);
      await profileImageRef.putFile(imageFile);

      await fAuth.currentUser?.updatePhotoURL(
        await profileImageRef.getDownloadURL(),
      );

      _inProgress = false;
      update();

      return true;
    } on FirebaseAuthException catch (e) {
      _inProgress = false;
      _errorMessage = e.message?.toString() ?? "Reason unknown";
      update();
      return false;
    }
  }
}
