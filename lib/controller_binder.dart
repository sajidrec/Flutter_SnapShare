import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/auth_controller/login_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/registration_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/selected_image_name_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/update_profile_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/upload_user_info_db_controller.dart';
import 'package:snapshare/presentation/controller/chat_controller/chat_list_screen_controller.dart';
import 'package:snapshare/presentation/controller/chat_controller/chat_screen_controller.dart';
import 'package:snapshare/presentation/controller/follow_unfollow_screen_controller.dart';
import 'package:snapshare/presentation/controller/follow_unfollow_toggle_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';
import 'package:snapshare/presentation/controller/grid_or_listview_switch_controller.dart';
import 'package:snapshare/presentation/controller/notification_screen_controller.dart';
import 'package:snapshare/presentation/controller/others_profile_screen_controller.dart';
import 'package:snapshare/presentation/controller/post_controller/get_post_images_by_username_controller.dart';
import 'package:snapshare/presentation/controller/post_controller/get_post_info_controller.dart';
import 'package:snapshare/presentation/controller/search_screen_controller.dart';
import 'package:snapshare/presentation/controller/story_controller.dart';

import 'presentation/controller/post_controller/get_post_images_by_uid_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(RegistrationController());
    Get.put(LoginController());
    Get.put(GridOrListviewSwitchController());
    Get.put(SelectedImageNameController());
    Get.put(UploadUserInfoDbController());
    Get.put(GetUserinfoByEmailController());
    Get.put(GetUserinfoByUsernameController());
    Get.put(UpdateProfileController());
    Get.put(SearchScreenController());
    Get.put(OthersProfileScreenController());
    Get.put(FollowUnfollowToggleController());
    Get.put(GetPostInfoController());
    Get.put(FollowUnfollowScreenController());
    Get.put(GetPostImagesByUidController());
    Get.put(GetPostImagesByUsernameController());
    Get.put(NotificationScreenController());
    Get.put(ChatListScreenController());
    Get.put(ChatScreenController());
    Get.put(StoryController());
  }
}
