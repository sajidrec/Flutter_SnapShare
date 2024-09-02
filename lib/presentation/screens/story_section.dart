import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/controller/story_controller.dart';
import 'package:snapshare/widgets/story_card.dart';

class StorySection extends StatelessWidget {
  StorySection({super.key});

  final StoryController _storyController = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final stories = _storyController.storyPosts;
        return SizedBox(
          height: 170,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: stories.length + 1, // Add 1 for the "Add Story" button
            itemBuilder: (context, index) {
              if (index == 0) {
                // Show the add button only at index 0
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      StoryCard(
                        title: 'Post Story',
                        profileImage: '',
                        onTap: () {
                          showAddDialog();
                        },
                      ),
                    ],
                  ),
                );
              } else {
                final story = stories[index - 1]; // Adjust index for stories
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoryCard(
                    image: story.imageUrl,
                    title: story.username,
                    profileImage: story.userProfilePic,
                    onTap: () {},
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  void showAddDialog() {
    Get.dialog(
      AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 300,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Post Story',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _storyController
                                .pickImageForStory(ImageSource.camera);
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _storyController
                                .pickImageForStory(ImageSource.gallery);
                          },
                          icon: const Icon(
                            Icons.image_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
