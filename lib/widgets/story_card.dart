import 'package:flutter/material.dart';
import 'package:snapshare/widgets/profile_image_button.dart';

class StoryCard extends StatelessWidget {
  final String image;
  final String title;
  final String profileImage;

  const StoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 170,
      decoration: BoxDecoration(
        color: Colors.white60,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: _buildProfileImageSection(),
    );
  }

  Column _buildProfileImageSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                width: 90,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: ProfileImageButton(profileImage: profileImage),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
