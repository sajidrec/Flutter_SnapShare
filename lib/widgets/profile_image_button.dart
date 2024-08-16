import 'package:flutter/material.dart';

class ProfileImageButton extends StatelessWidget {
  final String? profileImage;

  const ProfileImageButton({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundImage: profileImage != null ? AssetImage(profileImage!) : null,
    );
  }
}
