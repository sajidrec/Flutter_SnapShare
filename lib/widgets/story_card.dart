// import 'package:flutter/material.dart';
// import 'package:snapshare/widgets/profile_image_button.dart';
//
// class StoryCard extends StatelessWidget {
//   String image;
//   String title = 'Add Story';
//   final String? profileImage;
//
//   StoryCard({
//     super.key,
//     this.image,
//     required this.title,
//     this.profileImage,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 170,
//       decoration: BoxDecoration(
//         color: Colors.white60,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: _buildProfileImageSection(),
//     );
//   }
//
//   Column _buildProfileImageSection() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Stack(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Image.network(
//                 image!,
//                 width: 90,
//                 height: 120,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Positioned(
//               top: 4,
//               left: 4,
//               child: ProfileImageButton(profileImage: profileImage),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/widgets/profile_image_button.dart';

class StoryCard extends StatelessWidget {
  StoryCard({
    super.key,
    this.image,
    required this.title,
    required this.profileImage,
    required this.onTap,
  });

  VoidCallback onTap;
  final String? image;
  final String title;
  final String? profileImage;

  @override
  Widget build(BuildContext context) {
    final customColor = AppColor.forStory(context);

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
      child: _buildProfileImageSection(customColor, onTap),
    );
  }

  Column _buildProfileImageSection(Color customColor, onTap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            // Use a placeholder if image is null
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: image != null
                  ? Image.network(
                      image!,
                      width: 90,
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  : GestureDetector(
                      onTap: onTap,
                      child: Container(
                        width: 90,
                        height: 120,
                        color: Colors.grey[200], // Placeholder color
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                        ),
                      ),
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
          style: TextStyle(
            color: customColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
