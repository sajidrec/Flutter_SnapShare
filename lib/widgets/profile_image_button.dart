import 'package:flutter/material.dart';

class ProfileImageButton extends StatelessWidget {
  final String? profileImage;

  const ProfileImageButton({
    super.key,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundImage:
          profileImage!.isNotEmpty && profileImage!.startsWith('http')
              ? NetworkImage(profileImage!)
              : AssetImage(profileImage!) as ImageProvider,
      backgroundColor: Colors.transparent,
    );
  }
}
