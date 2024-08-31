import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/chat_controller/chat_screen_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.otherUsername,
  });

  final String otherUsername;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Get.find<GetUserinfoByEmailController>().fetchUserData(
            email: FirebaseAuth.instance.currentUser?.email ?? "");
        currentUserUsername = await Get.find<GetUserinfoByEmailController>()
            .getUserData["username"];
        await _fetchUserData();
      },
    );
  }

  Future<void> _fetchUserData() async {
    await Get.find<ChatScreenController>().fetchData(widget.otherUsername);
  }

  late String currentUserUsername = '';

  final TextEditingController _messageSentTEController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customColor = AppColor.forText(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Message',
            style: TextStyle(color: customColor),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: customColor,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildMessageSection(),
              _buildMessageInput(context, customColor),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context, Color customColor) {
    return TextField(
      controller: _messageSentTEController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: customColor,
            width: 2.0,
          ),
        ),
        suffixIcon: GetBuilder<ChatScreenController>(builder: (
          chatScreenController,
        ) {
          return IconButton(
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              await chatScreenController.sendMessage(
                message: _messageSentTEController.text.trim(),
                oppositeUsername: widget.otherUsername,
              );

              _messageSentTEController.clear();
            },
            icon: const Icon(
              Icons.send,
              color: AppColor.themeColor,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMessageSection() {
    return Expanded(
      child: GetBuilder<ChatScreenController>(
        builder: (chatScreenController) {
          return chatScreenController.inProgress
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.themeColor,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (chatScreenController
                            .getChattingData[index].senderName ==
                        (currentUserUsername)) {
                      return _buildMessageFromCurrentUser(
                        msg: chatScreenController
                                .getChattingData[index].messageText ??
                            "",
                      );
                    } else {
                      return _buildMessageFromOtherUser(
                        msg: chatScreenController
                                .getChattingData[index].messageText ??
                            "",
                      );
                    }
                  },
                  itemCount: chatScreenController.getChattingData.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Padding(padding: EdgeInsets.all(5.0));
                  },
                );
        },
      ),
    );
  }

  Widget _buildMessageFromCurrentUser({
    required String msg,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageFromOtherUser({
    required String msg,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            msg,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _messageSentTEController.dispose();
  }
}
