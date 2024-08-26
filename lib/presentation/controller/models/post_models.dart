import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final List<String> comments;
  final String imageUrl;
  final List<String> likes;
  final List<String> locations;
  final String postId;
  final DateTime timestamp;
  final String userId;
  final String userFullName;
  final String userProfilePic;
  final String username;


  Post({
    required this.caption,
    required this.comments,
    required this.imageUrl,
    required this.likes,
    required this.locations,
    required this.postId,
    required this.timestamp,
    required this.userId,
    required this.userFullName,
    required this.userProfilePic,
    required this.username,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    print('Document data: ${doc.data()}');
    return Post(
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      locations: List<String>.from(data['locations'] ?? ''),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      comments: List<String>.from(data['comments'] ?? []),
      userFullName: data['userFullName'] ?? '',
      userProfilePic: data['userProfilePic'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
