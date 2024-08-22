// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
//
// class UploadUserInfoDbController extends GetxController {
//   Future<bool> uploadUserInfo({
//     required String username,
//     required String userFullName,
//     required String userEmail,
//   }) async {
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//
//     final docRef = firebaseFirestore.collection("userInfo").doc(username);
//     final docSnapshot = await docRef.get();
//
//     if (docSnapshot.exists) {
//       return false;
//     }
//
//     try {
//       await firebaseFirestore.collection("userInfo").doc(username).set(
//         {
//           "username": username,
//           "fullName": userFullName,
//           "email": userEmail,
//           "followers": [],
//           "following": [],
//           "messages": [],
//           "posts": [],
//         },
//       );
//     } catch (e) {
//       return false;
//     }
//
//     return true;
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UploadUserInfoDbController extends GetxController {
  Future<bool> uploadUserInfo({
    required String uid,
    required String username,
    required String userFullName,
    required String userEmail,
  }) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final docRef = firebaseFirestore.collection("userInfo").doc(uid);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return false; // Document already exists
    }

    try {
      await firebaseFirestore.collection("userInfo").doc(uid).set(
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
      return false; // Handle exception
    }

    return true;
  }
}
