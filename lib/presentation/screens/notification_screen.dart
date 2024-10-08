import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/notification_screen_controller.dart';
import 'package:snapshare/utils/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        return await Get.find<NotificationScreenController>()
            .fetchNotification();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppColor.forText(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildAppbar(textColor),
            _buildHorizontalLine(),
            const SizedBox(height: 10),
            Expanded(
              child: GetBuilder<NotificationScreenController>(
                  builder: (notificationScreenController) {
                return notificationScreenController.inProgress
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColor.themeColor,
                        ),
                      )
                    : notificationScreenController.getNotificationList.isEmpty
                        ? Text(
                            "No notification yet",
                            style: TextStyle(color: textColor),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) => _buildNotification(
                              textColor: textColor,
                              photoUrl: notificationScreenController
                                      .getNotificationList[index].photoUrl ??
                                  "",
                              notificationMsg: notificationScreenController
                                      .getNotificationList[index]
                                      .notificationMessage ??
                                  "",
                              fromNotificationUserName:
                                  notificationScreenController
                                          .getNotificationList[index].name ??
                                      "",
                            ),
                            itemCount: notificationScreenController
                                .getNotificationList.length,
                          );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification({
    required String photoUrl,
    required String notificationMsg,
    required String fromNotificationUserName,
    required Color textColor,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  photoUrl,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: Get.width / 1.35,
                      child: Text(
                        "$fromNotificationUserName loves your post $notificationMsg",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: textColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildHorizontalLine(),
      ],
    );
  }

  Widget _buildHorizontalLine() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      width: double.maxFinite,
      height: 2,
    );
  }

  Widget _buildAppbar(Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: textColor,
            ),
          ),
          Text(
            "Notification",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w700, color: textColor),
          ),
        ],
      ),
    );
  }
}
