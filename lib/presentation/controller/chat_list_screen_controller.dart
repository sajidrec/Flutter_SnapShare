import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';
import 'package:snapshare/presentation/models/message_chat_element_model.dart';

class ChatListScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  final List<MessageChatElementModel> _listOfMessagesUser = [];

  List<MessageChatElementModel> get getListOfMessagesUser =>
      _listOfMessagesUser;

  Future<void> fetchData() async {
    _inProgress = true;
    _listOfMessagesUser.clear();
    update();

    await Get.find<GetUserinfoByEmailController>().fetchUserData(
      email: FirebaseAuth.instance.currentUser?.email ?? "",
    );
    for (int i = 0;
        i <
            Get.find<GetUserinfoByEmailController>()
                .getUserData["messages"]
                .length;
        i++) {
      String chatUserUsername =
          Get.find<GetUserinfoByEmailController>().getUserData["messages"][i];

      await Get.find<GetUserinfoByUsernameController>()
          .fetchUserData(username: chatUserUsername);

      MessageChatElementModel messageChatElementModel = MessageChatElementModel(
        username:
            Get.find<GetUserinfoByEmailController>().getUserData["messages"][i],
        userFullName:
            Get.find<GetUserinfoByUsernameController>().getUserData["fullName"],
        userPhoto: Get.find<GetUserinfoByUsernameController>()
            .getUserData["profilePic"],
      );
      _listOfMessagesUser.add(messageChatElementModel);
    }

    _inProgress = false;
    update();
  }
}
