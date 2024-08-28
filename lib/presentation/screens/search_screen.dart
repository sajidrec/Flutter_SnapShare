import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snapshare/presentation/controller/follow_unfollow_toggle_controller.dart';
import 'package:snapshare/presentation/controller/get_userinfo_by_email_controller.dart';
import 'package:snapshare/presentation/controller/search_screen_controller.dart';
import 'package:snapshare/presentation/screens/others_profile_screen.dart';

import '../../utils/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTEController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllUser();
  }

  Future<void> fetchAllUser() async {
    await Get.find<SearchScreenController>().fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearchInput(),
            const SizedBox(height: 20),
            _buildSearchResultView(),
          ],
        ),
      )),
    );
  }

  Widget _buildSearchResultView() {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme ? Colors.white70 : Colors.black;
    return Expanded(
      child: GetBuilder<SearchScreenController>(
        builder: (getAllUserinfo) {
          return getAllUserinfo.inProgress
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.themeColor,
                  ),
                )
              : GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: getAllUserinfo.getData.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return GridTile(
                      child: GetBuilder<GetUserinfoByEmailController>(
                          builder: (getUserInfoByEmailController) {
                        return GetBuilder<FollowUnfollowToggleController>(
                            builder: (followUnfollowToggleController) {
                          return InkWell(
                            onTap: () async {
                              await getUserInfoByEmailController.fetchUserData(
                                email:
                                    FirebaseAuth.instance.currentUser?.email ??
                                        "",
                              );
                              final currentUserData =
                                  await getUserInfoByEmailController
                                      .getUserData;

                              followUnfollowToggleController.setInitialStatus(
                                  status: await currentUserData["following"]
                                      .contains(
                                getAllUserinfo.getData[index]["username"],
                              ));

                              Get.to(
                                OthersProfileScreen(
                                  username: getAllUserinfo.getData[index]
                                      ["username"],
                                  userFullName: getAllUserinfo.getData[index]
                                      ["fullName"],
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    // Adjust radius as needed
                                    child: Image.network(
                                      getAllUserinfo.getData[index]
                                          ["profilePic"],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  "@${getAllUserinfo.getData[index]["username"]}",
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          );
                        });
                      }),
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildSearchInput() {
    return GetBuilder<SearchScreenController>(
        builder: (searchScreenController) {
      return TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          searchScreenController.fetchInfo(
            username: value,
          );
        },
        controller: _searchTEController,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          prefixIcon: IconButton(
            onPressed: () {
              searchScreenController.fetchInfo(
                username: _searchTEController.text,
              );
            },
            icon: const Icon(CupertinoIcons.search),
          ),
          hintText: "Search",
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColor.inputBorderColor),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchTEController.dispose();
  }
}
