import 'package:flutter/material.dart';
import 'package:snapshare/utils/app_colors.dart';

class CheckBox extends StatefulWidget {
  const CheckBox({super.key});

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          activeColor: AppColor.themeColor,
          onChanged: (value) {
            setState(() {
              isChecked = value;
            });
          },
        ),
        const SizedBox(width: 5),
        const Text(
          "Save password",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        )
      ],
    );
  }
}
