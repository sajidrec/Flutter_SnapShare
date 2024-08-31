import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/post_controller/new_post_controller.dart';
import 'package:snapshare/presentation/models/post_models.dart';
import 'package:snapshare/presentation/screens/chat_screens/chat_list_screen.dart';
import 'package:snapshare/presentation/screens/profile_screen.dart';
import 'package:snapshare/presentation/screens/update_profile_screen.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/widgets/comment_bottom_sheet.dart';
import 'package:snapshare/widgets/profile_image_button.dart';
import 'package:snapshare/widgets/story_section.dart';

import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewPostController newPostController = Get.put(NewPostController());
  final TextEditingController _commentController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              _buildTopSection(),
              _buildPostSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      color: Theme.of(context).colorScheme.primary,
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
                      Get.to(() => const ChatListScreen());
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
                  color: Theme.of(context).colorScheme.secondary,
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
          _buildPostImageSection(imageUrl, post.caption),
          const SizedBox(height: 12),
          _buildReactAndComment(post.postId, isLiked),
          const SizedBox(height: 8),
          Row(
            children: [
              ProfileImageButton(
                profileImage: FirebaseAuth.instance.currentUser?.photoURL ?? "",
              ),
              const SizedBox(width: 8),
              _buildComment(post.postId),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComment(String postId) {
    return Expanded(
      child: TextFormField(
        onTap: () {
          CommentBottomSheet.show(postId);
        },
        decoration: const InputDecoration(
            hintText: 'Your Comments',
            border: InputBorder.none,
            suffixIcon: Icon(Icons.send_outlined)),
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

  Widget _buildReactAndCommentRow(String postId, bool isLiked) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(
            CupertinoIcons.suit_heart_fill,
            size: 30,
          ),
          color: isLiked ? Colors.red : Colors.grey,
          onPressed: () async {
            final postDetails = await FirebaseFirestore.instance
                .collection("posts")
                .doc(postId)
                .get();

            if (isLiked) {
              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .update({
                'likes': FieldValue.arrayRemove(
                    [FirebaseAuth.instance.currentUser!.uid]),
              });

              if (postDetails["userId"] !=
                  FirebaseAuth.instance.currentUser?.uid) {
                await FirebaseFirestore.instance
                    .collection("userInfo")
                    .doc(postDetails["username"])
                    .update({
                  "notifications": FieldValue.arrayRemove([
                    {
                      FirebaseAuth.instance.currentUser?.email ?? "": postId,
                    },
                  ]),
                });
              }
            } else {
              await FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .update({
                'likes': FieldValue.arrayUnion(
                    [FirebaseAuth.instance.currentUser!.uid]),
              });

              if (postDetails["userId"] !=
                  FirebaseAuth.instance.currentUser?.uid) {
                await FirebaseFirestore.instance
                    .collection("userInfo")
                    .doc(postDetails["username"])
                    .update({
                  "notifications": FieldValue.arrayUnion([
                    {
                      FirebaseAuth.instance.currentUser?.email ?? "": postId,
                    },
                  ]),
                });
              }
            }

            setState(() {});
          },
        ),
        IconButton(
          onPressed: () {
            CommentBottomSheet.show(postId);
          },
          icon: const Icon(
            CupertinoIcons.chat_bubble,
            size: 22,
          ),
        ),
        TextButton(
          onPressed: () {
            CommentBottomSheet.show(postId);
          },
          child: const Text(
            'Comments',
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

  Widget _buildPostImageSection(String image, String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 350,
          ),
        ),
      ],
    );
  }

  Widget _buildPostTitleAndIcon(Post post) {
    return Row(
      children: [
        ProfileImageButton(
          profileImage: post.userProfilePic,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.userFullName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              post.locations.join(',\n '),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.black87,
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white : Colors.black;
    return Text(
      'SnapShare',
      style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          fontFamily: 'Lobster',
          color: textColor),
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
    final customColor = AppColor.lightOrDark(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                Text(
                  'Profile Created',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: customColor),
                ),
                const SizedBox(height: 16),
                Text(
                  'Update your name, profile image,\nadditional number',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: customColor),
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
