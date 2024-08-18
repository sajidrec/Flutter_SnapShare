import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/screens/message_screen.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/utils/assets_path.dart';
import 'package:snapshare/widgets/profile_image_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? email;

  @override
  void initState() {
    super.initState();
    email = _auth.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          _buildHeaderSection(),
          _buildBodySection(),
        ],
      ),
    );
  }

  Widget _buildBodySection() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.79,
                      child: MessageScreen(
                        email: email ?? '',
                      ),
                    ),
                    Row(
                      children: [_textFieldForMessage(), _iconButton()],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldForMessage() {
    return Expanded(
      child: TextFormField(
        controller: chatController,
        decoration: const InputDecoration(
          hintText: 'Message',
          enabled: true,
          contentPadding: EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        ),
        onSaved: (value) {
          chatController.text = value!;
        },
      ),
    );
  }

  Widget _iconButton() {
    return IconButton(
        onPressed: () {
          if (chatController.text.isNotEmpty) {
            fireStore.collection('messages').doc().set({
              'message': chatController.text.trim(),
              'time': DateTime.now(),
              'email': email
            });
            chatController.clear();
          }
        },
        icon: const Icon(
          Icons.send_outlined,
          color: AppColor.themeColor,
        ));
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNameAndProfileImage(),
          Row(
            children: [
              _buildCircularIconButton(Icons.call, () {}),
              _buildCircularIconButton(Icons.video_call_outlined, () {})
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNameAndProfileImage() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios)),
        const ProfileImageButton(
          profileImage: AssetsPath.profileImage,
        ),
        const SizedBox(width: 8),
        _buildNameAndTime()
      ],
    );
  }

  Widget _buildNameAndTime() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Benjamin Moores',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Text(
          'Last seen 11:44 AM',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        )
      ],
    );
  }

  Widget _buildCircularIconButton(IconData icon, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 28, color: Colors.grey.shade800),
      ),
    );
  }
}
