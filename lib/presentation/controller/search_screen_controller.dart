import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SearchScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  List<Map<String, dynamic>> _data = [];

  List<Map<String, dynamic>> get getData => _data;

  Future<void> fetchInfo({
    String? username,
  }) async {
    _inProgress = true;
    update();

    _data.clear();

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final dbRef = firebaseFirestore.collection("userInfo");

    final db = await dbRef.get();

    for (int i = 0; i < db.docs.length; i++) {
      if (db.docs[i].data()["email"] !=
          FirebaseAuth.instance.currentUser?.email) {
        _data.add(db.docs[i].data());
      }
    }

    if (username != null) {
      if (username.length > 1) {
        if (username[0] == '@') {
          username = username.substring(1);
        }
      }
      for (int i = 0; i < db.docs.length; i++) {
        if (db.docs[i].data()["username"] == username) {
          _data = [db.docs[i].data()];
          break;
        }
      }
    }

    _inProgress = false;
    update();
  }
}
