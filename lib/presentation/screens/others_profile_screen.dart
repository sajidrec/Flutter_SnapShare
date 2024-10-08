import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:snapshare/presentation/controller/follow_unfollow_toggle_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_username_controller.dart';
import 'package:snapshare/presentation/controller/grid_or_listview_switch_controller.dart';
import 'package:snapshare/presentation/controller/others_profile_screen_controller.dart';
import 'package:snapshare/presentation/controller/post_controller/get_post_images_by_username_controller.dart';
import 'package:snapshare/presentation/screens/chat_screens/chat_screen.dart';
import 'package:snapshare/presentation/screens/follow_unfollow_screen.dart';
import 'package:snapshare/utils/app_colors.dart';

class OthersProfileScreen extends StatefulWidget {
  final String username;
  final String userFullName;

  const OthersProfileScreen({
    super.key,
    required this.username,
    required this.userFullName,
  });

  @override
  State<OthersProfileScreen> createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await fetchUserData(),
    );
  }

  Future<void> fetchUserData() async {
    await Get.find<GetUserinfoByUsernameController>().fetchUserData(
      username: widget.username,
    );
    await Get.find<GetPostImagesByUsernameController>().fetchData(
      username: widget.username,
    );
  }

  @override
  Widget build(BuildContext context) {
    final customColor = AppColor.forText(context);
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(customColor),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProfileHeader(customColor),
            ),
            Container(
              color: const Color(0xFFF5F5F6),
              width: double.maxFinite,
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      _buildHorizontalLine(),
                      _buildNavbar(customColor),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Expanded(
              child: _buildPostSection(customColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostSection(Color customColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GetBuilder<GridOrListviewSwitchController>(
        builder: (gridOrListViewController) {
          return SingleChildScrollView(
            child: GetBuilder<GetPostImagesByUsernameController>(
                builder: (getPostImagesByUsernameController) {
              return (getPostImagesByUsernameController
                      .getPostImageList.isEmpty)
                  ? Text(
                      "No post yet",
                      style: TextStyle(color: customColor),
                    )
                  : StaggeredGrid.count(
                      crossAxisCount:
                          gridOrListViewController.gridViewActive ? 4 : 1,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: List.generate(
                          getPostImagesByUsernameController
                              .getPostImageList.length, (index) {
                        return StaggeredGridTile.count(
                          crossAxisCellCount: _getCrossAxisCellCount(
                              index, gridOrListViewController.gridViewActive),
                          mainAxisCellCount: _getMainAxisCellCount(index),
                          child: _buildTile(
                            getPostImagesByUsernameController
                                .getPostImageList[index],
                          ),
                        );
                      }),
                    );
            }),
          );
        },
      ),
    );
  }

  int _getCrossAxisCellCount(int index, bool gridViewActive) {
    // Repeat pattern for mainAxisCellCount

    if (!gridViewActive) return 1;

    switch (index % 6) {
      case 0:
      case 4:
        return 2;
      case 1:
      case 2:
      case 3:
      case 5:
        return 1;
      default:
        return 1;
    }
  }

  int _getMainAxisCellCount(int index) {
    // Repeat pattern for mainAxisCellCount
    switch (index % 6) {
      case 0:
      case 4:
        return 2;
      case 1:
      case 2:
      case 3:
      case 5:
        return 1;
      default:
        return 1;
    }
  }

  Widget _buildTile(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            } else {
              return const Center(
                child: CupertinoActivityIndicator(
                  animating: true,
                  radius: 15.0,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.error),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHorizontalLine() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.grey.shade300,
        height: 2,
      ),
    );
  }

  Widget _buildNavbar(Color customColor) {
    return GetBuilder<GridOrListviewSwitchController>(
        builder: (gridOrListviewController) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildNavViewButton(
              buttonText: "Grid view",
              buttonIcon: const Icon(Icons.grid_view_outlined),
              callbackFunction: () {
                gridOrListviewController.changeView(
                  activateGridView: true,
                );
              },
              active: gridOrListviewController.gridViewActive,
              textColor: customColor),
          const SizedBox(
            width: 12,
          ),
          _buildNavViewButton(
              buttonText: "List view",
              buttonIcon: const Icon(Icons.list),
              callbackFunction: () {
                gridOrListviewController.changeView(
                  activateGridView: false,
                );
              },
              active: !gridOrListviewController.gridViewActive,
              textColor: customColor),
        ],
      );
    });
  }

  Widget _buildNavViewButton({
    required String buttonText,
    required Icon buttonIcon,
    required Callback callbackFunction,
    required bool active,
    required Color textColor,
  }) {
    return InkWell(
      onTap: callbackFunction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width / 4.6,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buttonIcon,
                    Text(
                      buttonText,
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                if (active) ...[
                  Container(
                    color: Colors.black,
                    height: 2,
                    // width: 90,
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Color customColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfilePicture(),
        const SizedBox(width: 12),
        _buildProfileStatusSection(customColor),
      ],
    );
  }

  Widget _buildProfileStatusSection(Color customColor) {
    return GetBuilder<GetUserinfoByUsernameController>(
        builder: (getUserinfoByUsernameController) {
      return getUserinfoByUsernameController.inProgress
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStatus(
                        statusTitle: "Post",
                        statusQuantity: getUserinfoByUsernameController
                                .getUserData["posts"].length ??
                            0,
                        placeDotTrailing: true,
                        onTap: () {},
                        textColor: customColor),
                    _buildStatus(
                        statusTitle: "Following",
                        statusQuantity: getUserinfoByUsernameController
                                .getUserData["following"].length ??
                            0,
                        placeDotTrailing: true,
                        onTap: () async {
                          await Get.to(
                            () => FollowUnfollowScreen(
                              showFollowingList: true,
                              userFullName: widget.userFullName,
                              userName: widget.username,
                            ),
                          );
                          await fetchUserData();
                        },
                        textColor: customColor),
                    _buildStatus(
                        statusTitle: "Follower",
                        statusQuantity: getUserinfoByUsernameController
                                .getUserData["followers"].length ??
                            0,
                        placeDotTrailing: false,
                        onTap: () {
                          Get.to(
                            () => FollowUnfollowScreen(
                              showFollowingList: false,
                              userFullName: widget.userFullName,
                              userName: widget.username,
                            ),
                          );
                        },
                        textColor: customColor),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "@${widget.username}",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: customColor),
                ),
                Row(
                  children: [
                    GetBuilder<OthersProfileScreenController>(
                      builder: (othersProfileScreenController) {
                        return GetBuilder<FollowUnfollowToggleController>(
                          builder: (followUnfollowToggleController) {
                            return ElevatedButton(
                              onPressed: () async {
                                if (followUnfollowToggleController
                                    .isFollowing) {
                                  await othersProfileScreenController
                                      .unFollowUser(
                                    username: widget.username,
                                  );
                                } else {
                                  await othersProfileScreenController
                                      .followUser(
                                    username: widget.username,
                                  );
                                }

                                followUnfollowToggleController.toggle();
                              },
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0XFFEAECF0)),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.black),
                              ),
                              child: GetBuilder<FollowUnfollowToggleController>(
                                builder: (followUnfollowToggleController) {
                                  return Text(
                                      followUnfollowToggleController.isFollowing
                                          ? "Unfollow"
                                          : "Follow");
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(
                          ChatScreen(
                            otherUsername: widget.username,
                          ),
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0XFFEAECF0)),
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                      child: const Text("Message"),
                    ),
                  ],
                ),
              ],
            );
    });
  }

  Widget _buildStatus({
    required String statusTitle,
    required int statusQuantity,
    required bool placeDotTrailing,
    required VoidCallback onTap,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            statusQuantity.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14, color: textColor),
          ),
          Text(
            " ",
            style: TextStyle(color: textColor),
          ),
          Text(statusTitle, style: TextStyle(color: textColor)),
          if (placeDotTrailing) ...[
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              width: 5,
              height: 5,
            ),
            const SizedBox(width: 8),
          ]
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GetBuilder<GetUserinfoByUsernameController>(
        builder: (getUserinfoByUsernameController) {
      return CircleAvatar(
        radius: Get.width / 9,
        foregroundImage: NetworkImage(
          getUserinfoByUsernameController.getUserData["profilePic"] ?? "",
        ),
        backgroundColor: Colors.grey.shade500,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: Get.width / 7,
        ),
      );
    });
  }

  AppBar _buildAppbar(Color customColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: customColor)),
      title: Text(
        widget.userFullName,
        style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 20, color: customColor),
      ),
    );
  }
}
