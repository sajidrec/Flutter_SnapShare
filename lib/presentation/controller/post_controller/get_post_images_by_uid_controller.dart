import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';

class GetPostImagesByUidController extends GetxController {
  List<String> _postImageList = [];

  List<String> get getPostImageList => _postImageList;

  Future<void> fetchData({
    required String uid,
    required String email,
  }) async {
    _postImageList = [];

    await Get.find<GetUserinfoByEmailController>().fetchUserData(email: email);
    final user = Get.find<GetUserinfoByEmailController>().getUserData;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final allPostWithCurrentUser = await firebaseFirestore
        .collection("posts")
        .where("userId", isEqualTo: user["uid"])
        .get();

    for (int i = 0; i < allPostWithCurrentUser.size; i++) {
      _postImageList.add(allPostWithCurrentUser.docs[i]["imageUrl"]);
    }

    update();
  }
}
