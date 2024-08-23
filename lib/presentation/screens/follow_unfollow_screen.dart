import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/screens/others_profile_screen.dart';
import 'package:snapshare/utils/app_colors.dart';
import 'package:snapshare/utils/assets_path.dart';
import 'package:snapshare/widgets/profile_image_button.dart';

class FollowUnfollowScreen extends StatefulWidget {
  const FollowUnfollowScreen({super.key});

  @override
  State<FollowUnfollowScreen> createState() => _FollowUnfollowScreenState();
}

class _FollowUnfollowScreenState extends State<FollowUnfollowScreen> {
  bool isFollowing = false;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> users = [
    {'name': 'Sajid', 'username': 'sajidrec', 'isFollowing': true},
    {'name': 'Sagor Ahmed', 'username': '@shagor.a', 'isFollowing': true},
    {'name': 'John Doe', 'username': '@johnd', 'isFollowing': false},
    {'name': 'Jane Smith', 'username': '@janes', 'isFollowing': true},
    {'name': 'Henry Civil', 'username': '@henry', 'isFollowing': false},
    {'name': 'Nicolas Caidge', 'username': '@nicolas', 'isFollowing': true},
    {'name': 'Tom Cruse', 'username': '@cruse', 'isFollowing': true},
    {'name': 'Cory Anderson', 'username': '@anderson', 'isFollowing': true},
    {'name': 'Alice Brown', 'username': '@aliceb', 'isFollowing': true},
    {'name': 'Bob Johnson', 'username': '@bobj', 'isFollowing': true},
    {'name': 'Charlie Davis', 'username': '@charlied', 'isFollowing': true},
  ];

  List<Map<String, dynamic>> searchUsers = [];

  @override
  void initState() {
    super.initState();
    searchUsers = users;
  }

  void _searchUsersList() {
    setState(() {});
    searchUsers = users.where((userData) {
      return userData['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          userData['username']
              .toString()
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabs(),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) => _searchUsersList(),
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isFollowing ? _buildFollowingList() : _buildFollowerList(),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        FirebaseAuth.instance.currentUser?.displayName ?? "Unknown",
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildTabButton('Following', isFollowing, () {
            setState(() {});
            isFollowing = true;
          }),
          const SizedBox(width: 10),
          _buildTabButton('Followers', !isFollowing, () {
            setState(() {});
            isFollowing = false;
          }),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.black : Colors.grey),
          ),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              height: 2.0,
              width: 60.0,
              color: isSelected ? Colors.black : Colors.transparent)
        ],
      ),
    );
  }

  Widget _buildFollowingList() {
    return ListView.builder(
      itemCount: searchUsers.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Get.to(
              OthersProfileScreen(
                username: searchUsers[index]['username'],
                userFullName: searchUsers[index]['name'],
              ),
            );
          },
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(AssetsPath.photo2),
            ),
            title: Text(searchUsers[index]['name']),
            subtitle: Text(searchUsers[index]['username']),
            trailing: ElevatedButton(
                onPressed: () {
                  setState(() {});
                  searchUsers[index]['isFollowing'] =
                      !searchUsers[index]['isFollowing'];
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: searchUsers[index]['isFollowing']
                        ? AppColor.themeColor
                        : Colors.grey.shade400),
                child: Text(
                  searchUsers[index]['isFollowing'] ? 'Unfollow' : 'Follow',
                  style: const TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600),
                )),
          ),
        );
      },
    );
  }

  Widget _buildFollowerList() {
    return ListView.builder(
      itemCount: searchUsers.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Get.to(
              OthersProfileScreen(
                username: searchUsers[index]['username'],
                userFullName: searchUsers[index]['name'],
              ),
            );
          },
          child: ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage(AssetsPath.photo2),
            ),
            title: Text(searchUsers[index]['name']),
            subtitle: Text(searchUsers[index]['username']),
            trailing: ElevatedButton(
                onPressed: () {
                  _showRemoveBottomSheet(index);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade400),
                child: const Text(
                  'Remove',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600),
                )),
          ),
        );
      },
    );
  }

  void _showRemoveBottomSheet(int index) {
    Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(16.0),
          height: 150,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              _buildProfileHeader(index),
              Center(
                child: TextButton(
                  onPressed: () {
                    users.removeAt(index);
                    searchUsers = users;
                    Get.back();
                    setState(() {});
                  },
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true);
  }

  Widget _buildProfileHeader(index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileImageButton(
          profileImage: AssetsPath.photo2,
        ),
        const SizedBox(width: 15),
        _buildProfileStatusSection(),
      ],
    );
  }

  Widget _buildProfileStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          FirebaseAuth.instance.currentUser?.displayName ?? "Unknown",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
