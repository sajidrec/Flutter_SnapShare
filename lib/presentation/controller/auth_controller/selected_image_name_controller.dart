import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImageNameController extends GetxController {
  String _pickedImageName = "Nothing selected";

  String get pickedImageName => _pickedImageName;

// void provideFileName({required XFile? pickedImage}) {
//   if (pickedImage == null) {
//     _pickedImageName = "Nothing selected";
//   } else {
//     _pickedImageName = pickedImage.name;
//   }
//   update();
// }

  void provideFileName({required XFile? pickedImage}) {
    // Your logic to handle the XFile
    // For example, store the file name or process the image
    if (pickedImage != null) {
      _pickedImageName = pickedImage.name; // or any other logic
    } else {
      _pickedImageName = '';
    }
    update();
  }
}
