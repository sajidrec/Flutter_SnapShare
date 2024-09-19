import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/models/notification_model.dart';

class NotificationScreenController extends GetxController {
  final List<NotificationModel> _notificationList = [];

  List<NotificationModel> get getNotificationList => _notificationList;

  bool _inProgress = false;

  bool get inProgress => _inProgress;

  Future<void> fetchNotification() async {
    _inProgress = true;
    update();

    _notificationList.clear();

    await Get.find<GetUserinfoByEmailController>().fetchUserData(
      email: FirebaseAuth.instance.currentUser?.email ?? "",
    );

    final loggedUser =
        await Get.find<GetUserinfoByEmailController>().getUserData;

    if (loggedUser.containsKey("notifications")) {
      for (int i = 0; i < loggedUser["notifications"].length; i++) {
        NotificationModel notificationModel = NotificationModel();

        await Get.find<GetUserinfoByEmailController>().fetchUserData(
          email: loggedUser["notifications"][i].keys.first ?? "",
        );
        final notiUser =
            await Get.find<GetUserinfoByEmailController>().getUserData;

        notificationModel.name = notiUser["fullName"];
        notificationModel.photoUrl = notiUser["profilePic"];

        String postId = loggedUser["notifications"][i].values.first;

        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

        final postDetails =
            await firebaseFirestore.collection("posts").doc(postId).get();

        notificationModel.notificationMessage = postDetails["caption"];

        _notificationList.add(notificationModel);
      }
    }

    _inProgress = false;
    update();
  }
}
