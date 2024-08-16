import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          const SizedBox(height: 45),
          const TextField(
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                prefixIcon: Icon(CupertinoIcons.search),
                hintText: "Search",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.inputBorderColor))),
          ),
          Expanded(
            child: GridView.builder(
              primary: false,
              itemCount: 100,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return GridTile(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // Adjust radius as needed
                    child:Image.network(
                      "https://img.freepik.com/free-photo/bearded-man-with-striped-shirt_273609-7180.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    ));
  }
}
