import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserinfoByEmailController extends GetxController {
  dynamic _userData;

  dynamic get getUserData => _userData;

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<dynamic> fetchUserData({
    required String email,
  }) async {
    _inProgress = true;
    update();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('userInfo')
        .where('email', isEqualTo: email)
        .get();
    _userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
    _inProgress = false;
    update();
  }
}
