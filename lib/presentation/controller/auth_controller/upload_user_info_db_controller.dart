import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UploadUserInfoDbController extends GetxController {
  Future<bool> uploadUserInfo({
    required String username,
    required String userFullName,
    required String userEmail,
  }) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    DocumentSnapshot documentSnapshotUsernameCheck =
        await firebaseFirestore.collection('userInfo').doc(username).get();

    final QuerySnapshot checkingEmailAlreadyRegistered = await FirebaseFirestore
        .instance
        .collection('userInfo')
        .where('email', isEqualTo: userEmail)
        .limit(1)
        .get();

    if (documentSnapshotUsernameCheck.exists ||
        checkingEmailAlreadyRegistered.docs.isNotEmpty) {
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
