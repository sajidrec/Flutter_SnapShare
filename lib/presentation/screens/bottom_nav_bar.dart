import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapshare/presentation/controller/new_post_controller.dart';
import 'package:snapshare/presentation/screens/home_screen.dart';
import 'package:snapshare/presentation/screens/profile_screen.dart';
import 'package:snapshare/presentation/screens/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final NewPostController _newPostController = Get.put(NewPostController());

  int _selectedPage = 0;

  final List<Widget> _screenList = [
    const HomeScreen(),
    const SearchScreen(),
    const Placeholder(),
    const ProfileScreen(),
  ];

  void _onItemClicked(int index) {
    if (index == 2) {
      showAddDialog();
    } else {
      setState(() {
        _selectedPage = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenList[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _onItemClicked,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavBarItem(Icons.home_outlined, 0),
          _buildNavBarItem(Icons.search_outlined, 1),
          _buildNavBarItem(Icons.add, 2),
          _buildNavBarItem(Icons.account_circle_outlined, 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData iconData, int index) {
    return BottomNavigationBarItem(
      icon: _selectedPage == index
          ? Container(
              padding:
                  const EdgeInsets.only(left: 15, top: 8, right: 15, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(2),
              ),
              child: Icon(iconData, color: Colors.blue),
            )
          : Icon(iconData),
      label: '',
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
                  'Select Image',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await _newPostController
                                .pickImageForBottomNav(ImageSource.camera);
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
                            await _newPostController
                                .pickImageForBottomNav(ImageSource.gallery);
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
