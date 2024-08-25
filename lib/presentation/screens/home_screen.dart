import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/models/post_models.dart';
import 'package:snapshare/presentation/screens/profile_screen.dart';
import 'package:snapshare/presentation/screens/update_profile_screen.dart';
import 'package:snapshare/widgets/comment_bottom_sheet.dart';
import 'package:snapshare/widgets/profile_image_button.dart';
import 'package:snapshare/widgets/story_section.dart';

import 'chat_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _commentController = TextEditingController();
  final Map<String, bool> _likedPostsList = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showProfileUpdateDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopSection(),
            _buildPostSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.to(() => const ProfileScreen()),
                  child: ProfileImageButton(
                    profileImage:
                        FirebaseAuth.instance.currentUser?.photoURL ?? "",
                  ),
                ),
                _buildHeaderLogo(),
                Row(
                  children: [
                    _buildCircularIconButton(Icons.notifications_none, () {
                      Get.to(const NotificationScreen());
                    }),
                    _buildCircularIconButton(Icons.message_outlined, () {
                      Get.to(() => const ChatScreen());
                    })
                  ],
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: StorySection(),
          )
        ],
      ),
    );
  }

  Widget _buildPostSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        final posts =
            snapshot.data!.docs.map((doc) => Post.fromDocument(doc)).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (BuildContext context, index) {
            final post = posts[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: _buildPostSectionBody(post),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPostSectionBody(Post post) {
    final String imageUrl = post.imageUrl;
    final bool isLiked =
        post.likes.contains(FirebaseAuth.instance.currentUser!.uid);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostTitleAndIcon(post),
          const SizedBox(height: 12),
          _buildPostImageSection(imageUrl),
          const SizedBox(height: 12),
          _buildReactAndComment(post.postId, isLiked),
          const SizedBox(height: 8),
          Row(
            children: [
              ProfileImageButton(
                profileImage: post.imageUrl,
              ),
              const SizedBox(width: 8),
              _buildComment(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComment() {
    return Expanded(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Your Comments',
          border: InputBorder.none,
        ),
        controller: _commentController,
      ),
    );
  }

  Widget _buildReactAndComment(String postId, bool isLiked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildReactAndCommentRow(postId, isLiked),
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.bookmark),
        ),
      ],
    );
  }

  // Widget _buildReactAndCommentRow(String postId, bool isLiked) {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: const EdgeInsets.all(4.0),
  //         child: IconButton(
  //           icon: const Icon(
  //             CupertinoIcons.suit_heart_fill,
  //             size: 30,
  //           ),
  //           color: isLiked ? Colors.red : Colors.grey,
  //           onPressed: () {
  //             setState(() {
  //               _likedPostsList[postId] = !(_likedPostsList[postId] ?? false);
  //               FirebaseFirestore.instance
  //                   .collection('posts')
  //                   .doc(postId)
  //                   .update({
  //                 'likes': FieldValue.arrayUnion(
  //                     [FirebaseAuth.instance.currentUser!.uid]),
  //               });
  //             });
  //           },
  //         ),
  //       ),
  //       IconButton(
  //         onPressed: () {
  //           CommentBottomSheet.show();
  //         },
  //         icon: const Icon(
  //           CupertinoIcons.chat_bubble,
  //           size: 22,
  //         ),
  //       ),
  //       TextButton(
  //         onPressed: () {
  //           CommentBottomSheet.show();
  //         },
  //         child: const Text(
  //           '20 Comments',
  //           style: TextStyle(
  //             fontSize: 17,
  //             color: Colors.black87,
  //             fontWeight: FontWeight.w400,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildReactAndCommentRow(String postId, bool isLiked) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.suit_heart_fill,
              size: 30,
            ),
            color: isLiked ? Colors.red : Colors.grey,
            onPressed: () {
              setState(() {
                if (isLiked) {
                  // If the post is already liked, unlike it
                  FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .update({
                    'likes': FieldValue.arrayRemove(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  });
                } else {
                  // If the post is not liked, like it
                  FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .update({
                    'likes': FieldValue.arrayUnion(
                        [FirebaseAuth.instance.currentUser!.uid]),
                  });
                }
              });
            },
          ),
        ),
        IconButton(
          onPressed: () {
            CommentBottomSheet.show();
          },
          icon: const Icon(
            CupertinoIcons.chat_bubble,
            size: 22,
          ),
        ),
        TextButton(
          onPressed: () {
            CommentBottomSheet.show();
          },
          child: const Text(
            '20 Comments',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostImageSection(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 300,
      ),
    );
  }

  Widget _buildPostTitleAndIcon(Post post) {
    return Row(
      children: [
        ProfileImageButton(
          profileImage: FirebaseAuth.instance.currentUser!.photoURL,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              FirebaseAuth.instance.currentUser?.displayName ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              post.caption,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ],
    );
  }

  Widget _buildHeaderLogo() {
    return const Text(
      'SnapShare',
      style: TextStyle(
          fontSize: 28, fontWeight: FontWeight.w500, fontFamily: 'Lobster'),
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

  void showProfileUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('https://i.imgur.com/BgdbRIQ.png'),
                const SizedBox(height: 16),
                const Text(
                  'Profile Created',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Update your name, profile image,\nadditional number',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const UpdateProfileScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 36),
                  ),
                  child: const Text('Update'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),
                        )),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
