import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/follow_unfollow_screen_controller.dart';
import 'package:snapshare/presentation/controller/follow_unfollow_toggle_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/screens/others_profile_screen.dart';

class FollowUnfollowScreen extends StatefulWidget {
  final bool showFollowingList;
  final String userFullName;
  final String userName;

  const FollowUnfollowScreen({
    super.key,
    required this.showFollowingList,
    required this.userFullName,
    required this.userName,
  });

  @override
  State<FollowUnfollowScreen> createState() => _FollowUnfollowScreenState();
}

class _FollowUnfollowScreenState extends State<FollowUnfollowScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool showFollowingList = true;

  @override
  void initState() {
    super.initState();
    showFollowingList = widget.showFollowingList;

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await fetchUserData(),
    );
  }

  Future<void> fetchUserData() async {
    await Get.find<FollowUnfollowScreenController>().fetchUser(
      username: widget.userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            _buildTabs(),
            _buildSearchInput(),
            Expanded(
              child: showFollowingList
                  ? _buildFollowingList()
                  : _buildFollowerList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GetBuilder<FollowUnfollowScreenController>(
        builder: (followUnfollowScreenController) {
          return TextFormField(
            controller: _searchController,
            onChanged: (value) {
              if (showFollowingList) {
                followUnfollowScreenController.fetchFollowingSearchUser(
                  searchKeyword: value,
                );
              } else {
                followUnfollowScreenController.fetchFollowerSearchUser(
                  searchKeyword: value,
                );
              }
            },
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.userFullName,
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
          _buildTabButton('Following', showFollowingList, () {
            setState(() {});
            showFollowingList = true;
          }),
          const SizedBox(width: 10),
          _buildTabButton('Followers', !showFollowingList, () {
            setState(() {});
            showFollowingList = false;
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
    return GetBuilder<FollowUnfollowScreenController>(
      builder: (followUnfollowScreenController) {
        return followUnfollowScreenController.searchedFollowingUser.isNotEmpty
            ? InkWell(
                onTap: () async {
                  bool userIsFollower = false;

                  await Get.find<GetUserinfoByEmailController>().fetchUserData(
                      email: FirebaseAuth.instance.currentUser?.email ?? "");

                  final followings = Get.find<GetUserinfoByEmailController>()
                      .getUserData["following"];

                  for (int i = 0;
                      (i < followings.length) && !userIsFollower;
                      i++) {
                    if (followings[i] ==
                        followUnfollowScreenController
                            .searchedFollowingUser["username"]) {
                      userIsFollower = true;
                    }
                  }

                  Get.find<FollowUnfollowToggleController>().setInitialStatus(
                    status: userIsFollower,
                  );

                  await Get.to(
                    OthersProfileScreen(
                      username: followUnfollowScreenController
                          .searchedFollowingUser["username"],
                      userFullName: followUnfollowScreenController
                          .searchedFollowingUser["fullName"],
                    ),
                  );

                  await fetchUserData();

                  Get.find<FollowUnfollowScreenController>()
                      .fetchFollowingSearchUser(
                          searchKeyword: followUnfollowScreenController
                              .searchedFollowingUser["username"]);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(followUnfollowScreenController
                        .searchedFollowingUser["profilePic"]),
                  ),
                  title: Text(
                    followUnfollowScreenController
                        .searchedFollowingUser["fullName"],
                  ),
                  subtitle: Text(
                    "@${followUnfollowScreenController.searchedFollowingUser["username"]}",
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: followUnfollowScreenController
                    .getFollowingUserDataList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    bool userIsFollower = false;

                    await Get.find<GetUserinfoByEmailController>()
                        .fetchUserData(
                            email:
                                FirebaseAuth.instance.currentUser?.email ?? "");

                    final followings = Get.find<GetUserinfoByEmailController>()
                        .getUserData["following"];

                    for (int i = 0;
                        (i < followings.length) && !userIsFollower;
                        i++) {
                      if (followings[i] ==
                          followUnfollowScreenController
                              .getFollowingUserDataList[index]["username"]) {
                        userIsFollower = true;
                      }
                    }

                    Get.find<FollowUnfollowToggleController>().setInitialStatus(
                      status: userIsFollower,
                    );

                    await Get.to(
                      OthersProfileScreen(
                        username: followUnfollowScreenController
                            .getFollowingUserDataList[index]["username"],
                        userFullName: followUnfollowScreenController
                            .getFollowingUserDataList[index]["fullName"],
                      ),
                    );
                    await fetchUserData();
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        followUnfollowScreenController
                            .getFollowingUserDataList[index]["profilePic"],
                      ),
                    ),
                    title: Text(
                      followUnfollowScreenController
                          .getFollowingUserDataList[index]["fullName"],
                    ),
                    subtitle: Text(
                      "@${followUnfollowScreenController.getFollowingUserDataList[index]["username"]}",
                    ),
                  ),
                ),
              );
      },
    );
  }

  Widget _buildFollowerList() {
    return GetBuilder<FollowUnfollowScreenController>(
      builder: (followUnfollowScreenController) {
        return followUnfollowScreenController.searchedFollowerUser.isNotEmpty
            ? InkWell(
                onTap: () async {
                  bool followingUser = false;

                  await Get.find<GetUserinfoByEmailController>().fetchUserData(
                      email: FirebaseAuth.instance.currentUser?.email ?? "");

                  final following = Get.find<GetUserinfoByEmailController>()
                      .getUserData["following"];

                  for (int i = 0;
                      (i < following.length) && !followingUser;
                      i++) {
                    if (following[i] ==
                        followUnfollowScreenController
                            .searchedFollowerUser["username"]) {
                      followingUser = true;
                    }
                  }

                  Get.find<FollowUnfollowToggleController>().setInitialStatus(
                    status: followingUser,
                  );

                  await Get.to(
                    OthersProfileScreen(
                      username: followUnfollowScreenController
                          .searchedFollowerUser["username"],
                      userFullName: followUnfollowScreenController
                          .searchedFollowerUser["fullName"],
                    ),
                  );

                  await fetchUserData();

                  Get.find<FollowUnfollowScreenController>()
                      .fetchFollowingSearchUser(
                          searchKeyword: followUnfollowScreenController
                              .searchedFollowerUser["username"]);
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(followUnfollowScreenController
                        .searchedFollowerUser["profilePic"]),
                  ),
                  title: Text(
                    followUnfollowScreenController
                        .searchedFollowerUser["fullName"],
                  ),
                  subtitle: Text(
                    "@${followUnfollowScreenController.searchedFollowerUser["username"]}",
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: followUnfollowScreenController
                    .getFollowersUserDataList.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () async {
                    bool followingUser = false;

                    await Get.find<GetUserinfoByEmailController>()
                        .fetchUserData(
                            email:
                                FirebaseAuth.instance.currentUser?.email ?? "");

                    final following = Get.find<GetUserinfoByEmailController>()
                        .getUserData["following"];

                    for (int i = 0;
                        (i < following.length) && !followingUser;
                        i++) {
                      if (following[i] ==
                          followUnfollowScreenController
                              .getFollowersUserDataList[index]["username"]) {
                        followingUser = true;
                      }
                    }

                    Get.find<FollowUnfollowToggleController>().setInitialStatus(
                      status: followingUser,
                    );

                    await Get.to(
                      OthersProfileScreen(
                        username: followUnfollowScreenController
                            .getFollowersUserDataList[index]["username"],
                        userFullName: followUnfollowScreenController
                            .getFollowersUserDataList[index]["fullName"],
                      ),
                    );
                    await fetchUserData();
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        followUnfollowScreenController
                            .getFollowersUserDataList[index]["profilePic"],
                      ),
                    ),
                    title: Text(
                      followUnfollowScreenController
                          .getFollowersUserDataList[index]["fullName"],
                    ),
                    subtitle: Text(
                      "@${followUnfollowScreenController.getFollowersUserDataList[index]["username"]}",
                    ),
                  ),
                ),
              );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
