import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';

class FollowUnfollowScreenController extends GetxController {
  List<Map<String, dynamic>> _followingUserDataList = [];

  List<Map<String, dynamic>> _followersUserDataList = [];

  List<Map<String, dynamic>> get getFollowingUserDataList =>
      _followingUserDataList;

  List<Map<String, dynamic>> get followersUserDataList =>
      _followersUserDataList;

  Map<String, dynamic> _searchedFollowingUser = {};

  Map<String, dynamic> get searchedFollowingUser => _searchedFollowingUser;

  Future<void> fetchUser({
    required String username,
  }) async {
    _followingUserDataList = [];
    _followersUserDataList = [];

    await Get.find<GetUserinfoByUsernameController>()
        .fetchUserData(username: username);

    Map<String, dynamic> userData =
        await Get.find<GetUserinfoByUsernameController>().getUserData;

    for (int i = 0; i < userData["following"].length; i++) {
      await Get.find<GetUserinfoByUsernameController>()
          .fetchUserData(username: userData["following"][i]);

      Map<String, dynamic> user =
          await Get.find<GetUserinfoByUsernameController>().getUserData;
      _followingUserDataList.add(user);
    }

    for (int i = 0; i < userData["followers"].length; i++) {
      await Get.find<GetUserinfoByUsernameController>()
          .fetchUserData(username: userData["followers"][i]);

      Map<String, dynamic> user =
          await Get.find<GetUserinfoByUsernameController>().getUserData;
      _followersUserDataList.add(user);
    }

    update();
  }

  void fetchFollowingSearchUser({
    required String searchKeyword,
  }) {
    if (searchKeyword.isNotEmpty) {
      if (searchKeyword[0] == '@') {
        searchKeyword = searchKeyword.substring(1);
      }
    }
    bool found = false;
    for (int i = 0; i < _followingUserDataList.length; i++) {
      if (searchKeyword == _followingUserDataList[i]["username"]) {
        _searchedFollowingUser = _followingUserDataList[i];
        found = true;
      }
    }
    if (!found) {
      _searchedFollowingUser = {};
    }
    update();
  }
}
