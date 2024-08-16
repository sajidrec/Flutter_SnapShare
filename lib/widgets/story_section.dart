import 'package:flutter/material.dart';
import 'package:snapshare/utils/assets_path.dart';
import 'package:snapshare/widgets/story_card.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  final List<Map<String, String>> stories = const [
    {
      'image': AssetsPath.photo5,
      'title': 'You',
      'profileImage': AssetsPath.photo5
    },
    {
      'image': AssetsPath.photo2,
      'title': 'John Doe',
      'profileImage': AssetsPath.photo2
    },
    {
      'image': AssetsPath.photo3,
      'title': 'John Lite',
      'profileImage': AssetsPath.photo3
    },
    {
      'image': AssetsPath.photo4,
      'title': 'Alia Kane',
      'profileImage': AssetsPath.photo4
    },
    {
      'image': AssetsPath.profileImage,
      'title': 'Alex Cary',
      'profileImage': AssetsPath.profileImage
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                StoryCard(
                  image: story['image']!,
                  title: story['title']!,
                  profileImage: story['profileImage']!,
                ),
                if (index == 0)
                  const Positioned(
                    top: 50,
                    left: 38,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
