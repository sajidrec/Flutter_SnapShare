import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/utils/assets_path.dart';

class CommentBottomSheet {
  static void show() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
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
              'Comment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _buildCommentItem(
                          username: 'mferdous12',
                          timeAgo: '2 hours ago',
                          commentText: 'Nice picture you have captured 🔥',
                        ),
                        _buildCommentItem(
                          username: 'mferdous12',
                          timeAgo: '2 hours ago',
                          commentText: 'Cool nature',
                        ),
                        _buildCommentItem(
                          username: 'mferdous12',
                          timeAgo: '2 hours ago',
                          commentText: 'Nice picture you have captured 🔥',
                        ),
                        _buildCommentItem(
                          username: 'mferdous12',
                          timeAgo: '2 hours ago',
                          commentText: 'Comments input here',
                        ),
                        // Add more comments here...
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildCommentInputField(),
          ],
        ),
      ),
    );
  }

  static Widget _buildCommentItem({
    required String username,
    required String timeAgo,
    required String commentText,
  }) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage(AssetsPath.photo5),
        radius: 20,
      ),
      title: Row(
        children: [
          Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Text(timeAgo,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(commentText),
          TextButton(
            onPressed: () {},
            child: const Text('Reply', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.favorite_border, color: Colors.grey),
        onPressed: () {},
      ),
    );
  }

  static Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage(AssetsPath.photo4),
            radius: 20,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Add comments',
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle comment submission
              Get.back(); // Close the bottom sheet after posting
            },
            child: const Text('Post', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
