import 'package:get/get.dart';

class GridOrListviewSwitchController extends GetxController {
  bool _gridViewActive = true;

  bool get gridViewActive => _gridViewActive;

  void changeView({
    required bool activateGridView,
  }) {
    _gridViewActive = activateGridView;
    update();
  }
}
