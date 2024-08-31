import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapshare/utils/app_colors.dart';

class MessageScreen extends StatefulWidget {
  final String email;

  const MessageScreen({super.key, required this.email});

  @override
  State<MessageScreen> createState() => _MessageScreenState(email: email);
}

class _MessageScreenState extends State<MessageScreen> {
  final String email;

  _MessageScreenState({required this.email});

  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection('messages')
      .orderBy('time')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return _buildListViewForMessage(snapshot);
      },
    );
  }

  Widget _buildListViewForMessage(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      itemBuilder: (_, index) {
        QueryDocumentSnapshot queryDocumentSnapshot =
            snapshot.data!.docs[index];
        Timestamp timestamp = queryDocumentSnapshot['time'];
        DateTime dateTime = timestamp.toDate();

        bool isCurrentUser = queryDocumentSnapshot['email'] == email;

        return _buildMessageAlignment(
            isCurrentUser, queryDocumentSnapshot, dateTime);
      },
    );
  }

  Widget _buildMessageAlignment(bool isCurrentUser,
      QueryDocumentSnapshot<Object?> queryDocumentSnapshot, DateTime dateTime) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppColor.themeColor.withOpacity(0.8)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: isCurrentUser
                ? const Radius.circular(10)
                : const Radius.circular(0),
            bottomRight: isCurrentUser
                ? const Radius.circular(0)
                : const Radius.circular(10),
          ),
        ),
        child: _buildMessageSection(
            isCurrentUser, queryDocumentSnapshot, dateTime),
      ),
    );
  }

  Widget _buildMessageSection(bool isCurrentUser,
      QueryDocumentSnapshot<Object?> queryDocumentSnapshot, DateTime dateTime) {
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _buildShowEmailOnChat(queryDocumentSnapshot, isCurrentUser),
        const SizedBox(height: 4),
        _buildTextMessage(queryDocumentSnapshot, isCurrentUser),
        const SizedBox(height: 4),
        _buildMessageTime(dateTime, isCurrentUser),
      ],
    );
  }

  Widget _buildShowEmailOnChat(
      QueryDocumentSnapshot<Object?> queryDocumentSnapshot,
      bool isCurrentUser) {
    return Text(
      queryDocumentSnapshot['email'],
      style: TextStyle(
        fontSize: 12,
        color: isCurrentUser ? Colors.white : Colors.black54,
      ),
    );
  }

  Widget _buildTextMessage(QueryDocumentSnapshot<Object?> queryDocumentSnapshot,
      bool isCurrentUser) {
    return Text(
      queryDocumentSnapshot['message'],
      style: TextStyle(
        fontSize: 16,
        color: isCurrentUser ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildMessageTime(DateTime dateTime, bool isCurrentUser) {
    return Text(
      '${dateTime.hour}:${dateTime.minute}',
      style: TextStyle(
        fontSize: 10,
        color: isCurrentUser ? Colors.white70 : Colors.black54,
      ),
    );
  }
}
