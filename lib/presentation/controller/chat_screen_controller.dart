import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';
import 'package:snapshare/presentation/models/message_info_model.dart';

class ChatScreenController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  final List<MessageInfoModel> _chatting = [];

  List<MessageInfoModel> get getChattingData => _chatting;

  Future<void> fetchData(String oppositeUsername) async {
    _inProgress = true;
    _chatting.clear();
    update();

    // opposite user chat fetch

    await Get.find<GetUserinfoByEmailController>()
        .fetchUserData(email: FirebaseAuth.instance.currentUser?.email ?? "");

    for (int i = 0;
        i <
            Get.find<GetUserinfoByEmailController>()
                .getUserData["messages"]
                .length;
        i++) {
      String messageString = jsonDecode(
          Get.find<GetUserinfoByEmailController>().getUserData["messages"][i]);
      Map<String, dynamic> data = jsonDecode(messageString);

      MessageInfoModel messageInfoModel = MessageInfoModel.fromJson(data);

      if (messageInfoModel.senderName == oppositeUsername) {
        _chatting.add(messageInfoModel);
      }
    }

    // currentUser chat fetch

    await Get.find<GetUserinfoByUsernameController>().fetchUserData(
      username: oppositeUsername,
    );

    for (int i = 0;
        i <
            Get.find<GetUserinfoByUsernameController>()
                .getUserData["messages"]
                .length;
        i++) {
      String messageString = jsonDecode(
          Get.find<GetUserinfoByUsernameController>().getUserData["messages"]
              [i]);
      Map<String, dynamic> data = jsonDecode(messageString);

      MessageInfoModel messageInfoModel = MessageInfoModel.fromJson(data);

      if (messageInfoModel.senderName ==
          await Get.find<GetUserinfoByEmailController>()
              .getUserData["username"]) {
        _chatting.add(messageInfoModel);
      }
    }

    // sort the list according message sent time
    _chatting.sort(
      (a, b) => a.messageSentTime!.compareTo(b.messageSentTime ?? 0),
    );

    _inProgress = false;
    update();
  }
}
