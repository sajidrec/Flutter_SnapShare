import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';

class OthersProfileScreenController extends GetxController {
  Future<void> followUser({
    required String username,
  }) async {
    await Get.find<GetUserinfoByUsernameController>().fetchUserData(
      username: username,
    );
    final otherUserData =
        await Get.find<GetUserinfoByUsernameController>().getUserData;
    await Get.find<GetUserinfoByEmailController>()
        .fetchUserData(email: FirebaseAuth.instance.currentUser?.email ?? "");
    final currentUserData =
        await Get.find<GetUserinfoByEmailController>().getUserData;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final dbRef =
        firebaseFirestore.collection("userInfo").doc(otherUserData["username"]);
    Set<String> allFollowers = {};
    final otherUserDbData = await dbRef.get();
    for (int i = 0; i < otherUserDbData["followers"].length; i++) {
      allFollowers.add(otherUserDbData["followers"][i]);
    }
    allFollowers.add(currentUserData["username"]);
    await dbRef.update({"followers": allFollowers.toList()});

    Set<String> allFollowing = {};
    final currentUserDbRef = firebaseFirestore
        .collection("userInfo")
        .doc(currentUserData["username"]);
    for (int i = 0; i < currentUserData["following"].length; i++) {
      allFollowing.add(currentUserData["following"][i]);
    }
    allFollowing.add(username);
    await currentUserDbRef.update({
      "following": allFollowing,
    });

    await Get.find<GetUserinfoByUsernameController>().fetchUserData(
      username: username,
    );
  }
}
