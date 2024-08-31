import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/chat_controller/chat_list_screen_controller.dart';
import 'package:snapshare/presentation/screens/chat_screens/chat_screen.dart';
import 'package:snapshare/utils/app_colors.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async =>
          await Get.find<ChatListScreenController>().fetchData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColor = AppColor.forText(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Users List',
            style: TextStyle(color: customColor),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: customColor,
          ),
        ),
        body: GetBuilder<ChatListScreenController>(
          builder: (chatListScreenController) {
            return chatListScreenController.inProgress
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.themeColor,
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: (chatListScreenController
                            .getListOfMessagesUser.isEmpty)
                        ? Center(
                            child: Text(
                              "No chat yet",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: customColor),
                            ),
                          )
                        : ListView.separated(
                            itemCount: chatListScreenController
                                .getListOfMessagesUser.length,
                            itemBuilder: (context, index) {
                              return _buildChatElement(
                                color: customColor,
                                chatListScreenController:
                                    chatListScreenController,
                                index: index,
                                onTap: () {
                                  Get.to(
                                    ChatScreen(
                                      otherUsername: chatListScreenController
                                              .getListOfMessagesUser[index]
                                              .username ??
                                          "",
                                    ),
                                  );
                                },
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                          ),
                  );
          },
        ),
      ),
    );
  }

  Widget _buildChatElement(
      {required ChatListScreenController chatListScreenController,
      required int index,
      required VoidCallback onTap,
      required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: Get.width / 15,
                  backgroundImage: NetworkImage(
                    chatListScreenController
                            .getListOfMessagesUser[index].userPhoto ??
                        "",
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chatListScreenController
                              .getListOfMessagesUser[index].userFullName ??
                          "",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: color),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "@${chatListScreenController.getListOfMessagesUser[index].username ?? ""}",
                      style: TextStyle(color: color),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
