import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UploadUserInfoDbController extends GetxController {
  Future<bool> uploadUserInfo({
    required String username,
    required String userFullName,
    required String userEmail,
  }) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final docRef = firebaseFirestore.collection("userInfo").doc(username);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return false;
    }

    try {
      await firebaseFirestore.collection("userInfo").doc(username).set(
        {
          "username": username,
          "fullName": userFullName,
          "email": userEmail,
          "followers": [],
          "following": [],
          "messages": [],
          "posts": [],
        },
      );
    } catch (e) {
      return false;
    }

    return true;
  }
}
