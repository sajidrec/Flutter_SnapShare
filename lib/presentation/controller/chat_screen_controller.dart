import 'package:cloud_firestore/cloud_firestore.dart';
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
      Map<String, dynamic> data =
          Get.find<GetUserinfoByEmailController>().getUserData["messages"][i];

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
      Map<String, dynamic> data = Get.find<GetUserinfoByUsernameController>()
          .getUserData["messages"][i];

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

  Future<void> sendMessage({
    required String message,
    required String oppositeUsername,
  }) async {
    await Get.find<GetUserinfoByEmailController>()
        .fetchUserData(email: FirebaseAuth.instance.currentUser?.email ?? "");

    final String currentUsername =
        await Get.find<GetUserinfoByEmailController>().getUserData["username"];

    MessageInfoModel messageInfoModel = MessageInfoModel(
      messageText: message,
      messageSentTime: DateTime.now().millisecondsSinceEpoch,
      senderName: currentUsername,
    );

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("userInfo")
        .doc(oppositeUsername)
        .update({
      "messages": FieldValue.arrayUnion([messageInfoModel.toJson()]),
    });

    await firebaseFirestore.collection("userInfo").doc(currentUsername).update({
      "chatList": FieldValue.arrayUnion(
        [oppositeUsername],
      ),
    });

    await firebaseFirestore
        .collection("userInfo")
        .doc(oppositeUsername)
        .update({
      "chatList": FieldValue.arrayUnion([currentUsername]),
    });

    _chatting.add(messageInfoModel);
    _chatting.sort(
      (a, b) => a.messageSentTime!.compareTo(b.messageSentTime ?? 0),
    );

    update();
  }
}
