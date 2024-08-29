import 'package:flutter/material.dart';
import 'package:snapshare/utils/app_colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildMessageSection(),
              _buildMessageInput(context),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () async {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          icon: const Icon(
            Icons.send,
            color: AppColor.themeColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageSection() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index % 2 == 0) {
            return _buildMessageFromCurrentUser(
              msg: "sajid",
            );
          } else {
            return _buildMessageFromOtherUser(
              msg: "sajid",
            );
          }
        },
        itemCount: 10,
        separatorBuilder: (BuildContext context, int index) {
          return const Padding(padding: EdgeInsets.all(5.0));
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
}
