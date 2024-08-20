import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/auth_controller/login_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/registration_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/selected_image_name_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/upload_user_info_db_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/grid_or_listview_switch_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';

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
  }
}
