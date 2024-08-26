import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetPostImagesByUsernameController extends GetxController {
  List<String> _postImageList = [];

  List<String> get getPostImageList => _postImageList;

  Future<void> fetchData({
    required String username,
  }) async {
    _postImageList = [];

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final allPostWithCurrentUser = await firebaseFirestore
        .collection("posts")
        .where("username", isEqualTo: username)
        .get();

    for (int i = 0; i < allPostWithCurrentUser.size; i++) {
      _postImageList.add(allPostWithCurrentUser.docs[i]["imageUrl"]);
    }
    
    update();
  }
}
