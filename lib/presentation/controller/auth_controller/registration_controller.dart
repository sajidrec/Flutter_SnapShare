import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    required String userFullName,
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

      await fAuth.currentUser?.updateDisplayName(userFullName);

      final storageRef = FirebaseStorage.instance.ref();
      final profileImageRef =
          storageRef.child("userProfilePictures/${fAuth.currentUser?.uid}");
      File imageFile = File(profilePicturePath);
      await profileImageRef.putFile(imageFile);

      await fAuth.currentUser?.updatePhotoURL(
        await profileImageRef.getDownloadURL(),
      );

      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final docRef = firebaseFirestore.collection("userInfo").doc(userName);

      await docRef.update(
        {
          "profilePic": await profileImageRef.getDownloadURL(),
          "uid": fAuth.currentUser?.uid,
        },
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
