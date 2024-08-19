import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildAppbar(),
            _buildHorizontalLine(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => _buildNotification(
                  photoUrl:
                      "https://thumbs.dreamstime.com/b/hacker-looking-camera-face-mask-dark-theme-wallpaper-hacker-looking-camera-face-mask-dark-theme-wallpaper-291465611.jpg",
                  notificationMsg:
                      "Sajid commented on someones photo click for more",
                  notificationTime: "12/12/12 10:30 AM",
                ),
                itemCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification({
    required String photoUrl,
    required String notificationMsg,
    required String notificationTime,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  photoUrl,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: Get.width / 1.35,
                      child: Text(
                        notificationMsg,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      notificationTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildHorizontalLine(),
      ],
    );
  }

  Widget _buildHorizontalLine() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
      ),
      width: double.maxFinite,
      height: 2,
    );
  }

  Widget _buildAppbar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          const Text(
            "Notification",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
