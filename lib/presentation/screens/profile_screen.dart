import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:snapshare/presentation/controller/get_post_images_by_uid_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/grid_or_listview_switch_controller.dart';
import 'package:snapshare/presentation/screens/auth/signup_or_login_screen.dart';
import 'package:snapshare/presentation/screens/follow_unfollow_screen.dart';
import 'package:snapshare/utils/app_colors.dart';

import 'bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await fetchUserData(),
    );
  }

  Future<void> fetchUserData() async {
    await Get.find<GetUserinfoByEmailController>()
        .fetchUserData(email: FirebaseAuth.instance.currentUser?.email ?? "");
    await Get.find<GetPostImagesByUidController>().fetchData(
      uid: FirebaseAuth.instance.currentUser?.uid ?? "",
      email: FirebaseAuth.instance.currentUser?.email ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppColor.forText(context);
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(textColor),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProfileHeader(textColor),
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
                      _buildNavbar(textColor),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            Expanded(
              child: _buildPostSection(textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostSection(Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GetBuilder<GridOrListviewSwitchController>(
        builder: (gridOrListViewController) {
          return SingleChildScrollView(
            child: GetBuilder<GetPostImagesByUidController>(
              builder: (getPostImagesByUidController) {
                return (getPostImagesByUidController.getPostImageList.isEmpty)
                    ? Text(
                        "No post yet",
                        style: TextStyle(color: textColor),
                      )
                    : StaggeredGrid.count(
                        crossAxisCount:
                            gridOrListViewController.gridViewActive ? 4 : 1,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: List.generate(
                          getPostImagesByUidController.getPostImageList.length,
                          (index) {
                            return StaggeredGridTile.count(
                              crossAxisCellCount: _getCrossAxisCellCount(index,
                                  gridOrListViewController.gridViewActive),
                              mainAxisCellCount: _getMainAxisCellCount(index),
                              child: _buildTile(getPostImagesByUidController
                                  .getPostImageList[index]),
                            );
                          },
                        ),
                      );
              },
            ),
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

  Widget _buildNavbar(Color textColor) {
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
            textColor: textColor,
          ),
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
            textColor: textColor,
          ),
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

  Widget _buildProfileHeader(Color textColor) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfilePicture(),
          const SizedBox(width: 12),
          _buildProfileStatusSection(textColor),
        ],
      ),
    );
  }

  Widget _buildProfileStatusSection(Color textColor) {
    return GetBuilder<GetUserinfoByEmailController>(
        builder: (getUserinfoByEmailController) {
      return getUserinfoByEmailController.inProgress
          ? const Center(
              child: CupertinoActivityIndicator(
                color: AppColor.themeColor,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? "Unknown",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: textColor),
                ),
                const SizedBox(height: 5),
                Text(
                  "@${getUserinfoByEmailController.getUserData["username"] ?? "Not available"}",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStatus(
                      statusTitle: "Post",
                      statusQuantity: getUserinfoByEmailController
                              .getUserData["posts"].length ??
                          0,
                      placeDotTrailing: true,
                      onTap: () {},
                      textColor: textColor,
                    ),
                    _buildStatus(
                      statusTitle: "Following",
                      statusQuantity: getUserinfoByEmailController
                              .getUserData["following"].length ??
                          0,
                      placeDotTrailing: true,
                      onTap: () async {
                        await Get.find<GetUserinfoByEmailController>()
                            .fetchUserData(
                                email:
                                    FirebaseAuth.instance.currentUser?.email ??
                                        "");
                        final username =
                            await Get.find<GetUserinfoByEmailController>()
                                .getUserData["username"];

                        await Get.to(
                          () => FollowUnfollowScreen(
                            showFollowingList: true,
                            userFullName: FirebaseAuth
                                    .instance.currentUser?.displayName ??
                                "Unknown",
                            userName: username,
                          ),
                        );

                        await fetchUserData();
                      },
                      textColor: textColor,
                    ),
                    _buildStatus(
                      statusTitle: "Follower",
                      statusQuantity: getUserinfoByEmailController
                              .getUserData["followers"].length ??
                          0,
                      placeDotTrailing: false,
                      onTap: () async {
                        await Get.find<GetUserinfoByEmailController>()
                            .fetchUserData(
                                email:
                                    FirebaseAuth.instance.currentUser?.email ??
                                        "");
                        final username =
                            await Get.find<GetUserinfoByEmailController>()
                                .getUserData["username"];
                        await Get.to(
                          () => FollowUnfollowScreen(
                            showFollowingList: false,
                            userFullName: FirebaseAuth
                                    .instance.currentUser?.displayName ??
                                "Unknown",
                            userName: username,
                          ),
                        );
                      },
                      textColor: textColor,
                    ),
                  ],
                ),
              ],
            );
    });
  }

  Widget _buildStatus(
      {required String statusTitle,
      required int statusQuantity,
      required bool placeDotTrailing,
      required VoidCallback onTap,
      required Color textColor}) {
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
          Text(
            statusTitle,
            style: TextStyle(color: textColor),
          ),
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
    return CircleAvatar(
      radius: Get.width / 9,
      foregroundImage: NetworkImage(
        FirebaseAuth.instance.currentUser?.photoURL ?? "",
      ),
      backgroundColor: Colors.grey.shade500,
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: Get.width / 7,
      ),
    );
  }

  AppBar _buildAppbar(Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Get.offAll(() => const BottomNavBar());
          },
          icon: Icon(Icons.arrow_back_ios, color: textColor)),
      actions: [
        IconButton(
          onPressed: () async {
            Get.defaultDialog(
              title: "Are you sure want to logout?",
              middleText: "",
              backgroundColor: Colors.white,
              cancel: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "NO",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              confirm: TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Get.offAll(const SignupOrLoginScreen());
                },
                child: const Text(
                  "YES",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
          icon: Icon(
            Icons.logout,
            color: textColor,
          ),
        )
      ],
      title: Text(
        "My Profile",
        style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 20, color: textColor),
      ),
    );
  }
}
