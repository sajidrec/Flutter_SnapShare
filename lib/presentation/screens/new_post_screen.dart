import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/widgets/location_screen.dart';

import '../controller/new_post_controller.dart';

class NewPostScreen extends StatefulWidget {
  final String imagePath;

  const NewPostScreen({super.key, required this.imagePath});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<String> selectedLocations = [];
  final TextEditingController _captionController = TextEditingController();
  final NewPostController _newPostController = Get.put(NewPostController());

  void _openLocationScreen() async {
    final result = await Get.to(() => const LocationScreen());
    if (result != null && result is List<String>) {
      setState(() {
        selectedLocations = result;
      });
    }
  }

  void _removeLocation(String location) {
    setState(() {
      selectedLocations.remove(location);
    });
  }

  void _postToFireStore() async {
    String? imageUrl =
        await _newPostController.uploadImage(File(widget.imagePath));

    if (imageUrl != null) {
      await _newPostController.createPost(
        imageUrl: imageUrl,
        caption: _captionController.text,
        locations: selectedLocations,
      );
    } else {
      Get.snackbar('Failed', 'Post failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildImageAndTextField(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: _openLocationScreen,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add Location',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        if (selectedLocations.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: selectedLocations.map((location) {
                              return Chip(
                                label: Text(location),
                                avatar: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                deleteIcon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ),
                                onDeleted: () => _removeLocation(location),
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 80),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Music',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 80),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildImageAndTextField() {
    return Row(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Image.file(File(widget.imagePath)),
        ),
        Expanded(
          child: TextFormField(
            controller: _captionController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Write a caption',
            ),
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: const Text(
        'New Post',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        TextButton(
          onPressed: _postToFireStore,
          child: const Text(
            'Post',
            style: TextStyle(
              color: AppColor.themeColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: AppColor.inputBorderColor,
        ),
      ],
    );
  }
}
