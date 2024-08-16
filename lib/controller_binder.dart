import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/auth_controller/login_controller.dart';
import 'package:snapshare/presentation/controller/auth_controller/registration_controller.dart';
import 'package:snapshare/presentation/controller/grid_or_listview_switch_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(RegistrationController());
    Get.put(LoginController());
    Get.put(GridOrListviewSwitchController());
  }
}
