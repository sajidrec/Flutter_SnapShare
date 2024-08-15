import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _errorMsg = "";

  String get errorMsg => _errorMsg;

  Future<bool> userLogin({
    required String email,
    required String password,
  }) async {
    _inProgress = true;
    update();

    try {
      FirebaseAuth fAuth = FirebaseAuth.instance;

      await fAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _inProgress = false;
      update();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMsg = e.code.toString();
      _inProgress = false;
      update();
      return false;
    }
  }
}
