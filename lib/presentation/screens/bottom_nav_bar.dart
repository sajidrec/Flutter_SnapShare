import 'package:flutter/material.dart';
import 'package:snapshare/presentation/screens/add_screen.dart';
import 'package:snapshare/presentation/screens/home_screen.dart'; // Assuming you have a HomeScreen
import 'package:snapshare/presentation/screens/profile_screen.dart';
import 'package:snapshare/presentation/screens/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedPage = 0;

  final List<Widget> _screenList = [
    const HomeScreen(),
    const SearchScreen(),
    const AddScreen(),
    const ProfileScreen()
  ];

  void _onItemClicked(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenList[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: _onItemClicked,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          _buildNavBarItem(Icons.home_outlined, 0),
          _buildNavBarItem(Icons.search_outlined, 1),
          _buildNavBarItem(Icons.add, 2),
          _buildNavBarItem(Icons.account_circle_outlined, 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(IconData iconData, int index) {
    return BottomNavigationBarItem(
      icon: _selectedPage == index
          ? Container(
              padding:
                  const EdgeInsets.only(left: 15, top: 8, right: 15, bottom: 8),
              // Padding around the icon
              decoration: BoxDecoration(
                color: Colors.blue.shade100, // Light blue background
                borderRadius: BorderRadius.circular(2), // Rounded corners
              ),
              child: Icon(iconData, color: Colors.blue), // Icon color
            )
          : Icon(iconData),
      label: '',
    );
  }
}
