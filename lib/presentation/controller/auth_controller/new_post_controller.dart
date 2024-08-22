import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NewPostController extends GetxController {
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<String?> _getUsername() async {
  //   try {
  //     DocumentSnapshot userDoc = await _firebaseFireStore
  //         .collection('userInfo')
  //         .doc(_auth.currentUser!.uid)
  //         .get();
  //
  //     if (userDoc.exists) {
  //       String? username = userDoc['username'] as String?;
  //       if (username != null && username.isNotEmpty) {
  //         return username;
  //       } else {
  //         print("Username field is empty or null");
  //         return null;
  //       }
  //     } else {
  //       print("Document does not exist for UID: ${_auth.currentUser!.uid}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error retrieving username: $e");
  //     return null;
  //   }
  // }

  Future<String?> _getUsername() async {
    try {
      String uid = _auth.currentUser!.uid;
      print("Fetching document for UID: $uid");

      DocumentSnapshot userDoc =
          await _firebaseFireStore.collection('userInfo').doc(uid).get();

      if (userDoc.exists) {
        print("Document found: ${userDoc.data()}");
        return userDoc['username'] as String?;
      } else {
        print("Document does not exist for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching username: ${e.toString()}");
      return null;
    }
  }

  Future<bool> addNewPost({
    required String postImage,
    required String caption,
    required String location,
    String? comment,
  }) async {
    String? username = await _getUsername();

    if (username == null) {
      print("Username not found");
      return false;
    }

    await _firebaseFireStore.collection('posts').doc().set({
      'postImage': postImage,
      'caption': caption,
      'location': location,
      'like': [],
      'uid': _auth.currentUser!.uid,
      'username': username,
      'comments': comment != null
          ? [
              {'username': username, 'comment': comment}
            ]
          : [],
    });

    return true;
  }

  Future<void> addCommentToPost(String postId, String comment) async {
    String? username = await _getUsername();

    if (username == null) {
      print("Username not found");
      return;
    }

    await _firebaseFireStore.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([
        {'username': username, 'comment': comment}
      ])
    });
  }
}
