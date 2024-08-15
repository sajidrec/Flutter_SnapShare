import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  String _errorMessage = "";

  String get errorMessage => _errorMessage;

  Future<bool> registerNewUser({
    required String email,
    required String password,
  }) async {
    _inProgress = true;
    update();
    try {
      FirebaseAuth fAuth = FirebaseAuth.instance;
      await fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _inProgress = false;
      update();

      return true;
    } on FirebaseAuthException catch (e) {
      _inProgress = false;
      _errorMessage = e.message?.toString() ?? "Reason unkown";
      update();
      return false;
    }
  }
}
