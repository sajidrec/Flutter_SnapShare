import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class GetPostInfoController extends GetxController {
  bool _inProgress = false;
  String _errorMessage = "";

  bool get inProgress => _inProgress;

  String get errorMessage => _errorMessage;

  Future<String?> uploadPostImage(File postImage) async {
    _inProgress = true;
    update();

    try {
      FirebaseAuth fAuth = FirebaseAuth.instance;
      User? currentUser = fAuth.currentUser;

      if (currentUser == null) {
        _inProgress = false;
        _errorMessage = "No user is currently signed in";
        update();
        return null;
      }

      final storageRef = FirebaseStorage.instance.ref();
      final postImageRef = storageRef.child(
          "postImages/${currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}");
      await postImageRef.putFile(postImage);

      String photoURL = await postImageRef.getDownloadURL();

      _inProgress = false;
      update();
      return photoURL;
    } on FirebaseAuthException catch (e) {
      _inProgress = false;
      _errorMessage = e.message ?? "Unknown error occurred";
      update();
      return null;
    }
  }
}
