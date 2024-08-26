import 'package:get/get.dart';

class FollowUnfollowToggleController extends GetxController {
  bool _following = false;

  bool get isFollowing => _following;

  void setInitialStatus({required bool status}) {
    _following = status;
  }

  void toggle() {
    _following = !_following;
    update();
  }
}
