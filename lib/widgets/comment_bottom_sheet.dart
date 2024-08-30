import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';
import 'package:snapshare/utils/assets_path.dart';

class CommentBottomSheet {
  static void show(String postId) {
    Get.bottomSheet(
      CommentBottomSheetWidget(postId: postId),
    );
  }
}

class CommentBottomSheetWidget extends StatefulWidget {
  final String postId;

  const CommentBottomSheetWidget({super.key, required this.postId});

  @override
  _CommentBottomSheetWidgetState createState() =>
      _CommentBottomSheetWidgetState();
}

class _CommentBottomSheetWidgetState extends State<CommentBottomSheetWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> _commentsStream;
  final GetUserinfoByUsernameController getUserinfoByUsernameController =
      Get.find<GetUserinfoByUsernameController>();

  @override
  void initState() {
    super.initState();
    _commentsStream = _fireStore
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Comments',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _commentsStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final commentData = comment.data() as Map<String, dynamic>;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage('${_auth.currentUser!.photoURL}'),
                        radius: 20,
                      ),
                      title: Row(
                        children: [
                          Text(commentData['username'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkTheme
                                    ? Colors.grey[400]
                                    : Colors.grey,
                              )),
                          const SizedBox(width: 5),
                          Text(
                            _formatTime(commentData['timestamp']?.toDate()),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commentData['text'],
                            style: TextStyle(
                              color:
                                  isDarkTheme ? Colors.grey[400] : Colors.grey,
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     _deleteComment(comment.id);
                          //   },
                          //   child: const Text('Delete',
                          //       style: TextStyle(color: Colors.red)),
                          // ),
                        ],
                      ),
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.favorite_border,
                      //       color: Colors.grey),
                      //   onPressed: () {},
                      // ),
                    );
                  },
                );
              },
            ),
          ),
          _buildCommentInputField(textColor),
        ],
      ),
    );
  }

  Widget _buildCommentInputField(Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(AssetsPath.photo4),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add comments',
                hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                border: InputBorder.none,
              ),
              style: TextStyle(color: textColor),
            ),
          ),
          TextButton(
            onPressed: () {
              _addComment();
            },
            child: const Text('Post', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final currentUser = _auth.currentUser;

    if (currentUser == null) return;

    try {
      await _fireStore
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'username': currentUser.displayName ?? 'Anonymous',
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add comment: $e');
    }
  }

  void _deleteComment(String commentId) async {
    try {
      await _fireStore
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete comment: $e');
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
