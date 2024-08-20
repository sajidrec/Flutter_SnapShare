import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserinfoByUsernameController extends GetxController {
  dynamic _userData;

  dynamic get getUserData => _userData;

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<void> fetchUserData({
    required String username,
  }) async {
    _inProgress = true;
    update();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final docRef = firebaseFirestore.collection("userInfo").doc(username);
    final theDoc = await docRef.get();

    _userData = theDoc.data() as Map<String, dynamic>;

    _inProgress = false;
    update();
  }
}
