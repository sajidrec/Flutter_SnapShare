import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/auth_controller/login_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/registration_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/selected_image_name_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/update_profile_controller.dart';
import 'package:snapshare/presentation/controller/grid_or_listview_switch_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(UpdateProfileController());
    Get.put(LoginController());
    Get.put(GridOrListviewSwitchController());
    Get.put(SelectedImageNameController());
    Get.put(RegistrationController());
  }
}
