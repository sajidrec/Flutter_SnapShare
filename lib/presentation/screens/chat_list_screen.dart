import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/chat_list_screen_controller.dart';
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
    return SafeArea(
      child: Scaffold(
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
                    child:
                        (chatListScreenController.getListOfMessagesUser.isEmpty)
                            ? const Center(
                                child: Text(
                                  "No chat yet",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: chatListScreenController
                                    .getListOfMessagesUser.length,
                                itemBuilder: (context, index) {
                                  return _buildChatElement(
                                    chatListScreenController:
                                        chatListScreenController,
                                    index: index,
                                    onTap: () {},
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

  Widget _buildChatElement({
    required ChatListScreenController chatListScreenController,
    required int index,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              const SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatListScreenController
                            .getListOfMessagesUser[index].userFullName ??
                        "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Text(
                      "@${chatListScreenController.getListOfMessagesUser[index].username ?? ""}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
