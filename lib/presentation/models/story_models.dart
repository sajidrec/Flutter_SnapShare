import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModels {
  final String postId;
  final String imageUrl;
  final String caption;
  final List<String> locations;
  final String userId;
  final String userFullName;
  final String userProfilePic;
  final String username;
  final List<String> likes;
  final List<String> comments;
  final Timestamp timestamp;

  StoryModels({
    required this.postId,
    required this.imageUrl,
    required this.caption,
    required this.locations,
    required this.userId,
    required this.userFullName,
    required this.userProfilePic,
    required this.username,
    required this.likes,
    required this.comments,
    required this.timestamp,
  });

  factory StoryModels.fromDocument(DocumentSnapshot doc) {
    return StoryModels(
      postId: doc['postId'] ?? '',
      imageUrl: doc['imageUrl'] ?? '',
      caption: doc['caption'] ?? '',
      locations: List<String>.from(doc['locations'] ?? []),
      userId: doc['userId'] ?? '',
      userFullName: doc['userFullName'] ?? '',
      userProfilePic: doc['userProfilePic'] ?? '',
      username: doc['username'] ?? '',
      likes: List<String>.from(doc['likes'] ?? []),
      comments: List<String>.from(doc['comments'] ?? []),
      timestamp: doc['timestamp'] ?? Timestamp.now(),
    );
  }
}
