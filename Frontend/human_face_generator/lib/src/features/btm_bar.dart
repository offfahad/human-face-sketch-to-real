import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:human_face_generator/src/constants/colors.dart';
import 'package:human_face_generator/src/features/authentication/screens/profile/profile_screen.dart';
import 'package:human_face_generator/src/features/liveSketching/screens/drawing_screen_mobile.dart';
import 'package:human_face_generator/src/features/withoutLive/screens/drawing_screen_without_live.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 1;
  final List<Map<String, dynamic>> _pages = [
    {'page': const DrawingScreenWithoutLive(), 'title': 'Practice'},
    {'page': const DrawingScreen(), 'title': 'Home'},
    {'page': const ProfileScreen(), 'title': 'User Screen'},
  ];
  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_pages[_selectedIndex]['title']),
      // ),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: tPrimaryColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white70,
        selectedItemColor: Colors.white,
        onTap: _selectedPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.edit : IconlyLight.edit),
            label: "Practice",
          ),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1
                ? IconlyBold.home
                : IconlyLight.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 2 ? IconlyBold.profile : IconlyLight.profile),
            label: "Me",
          ),
        ],
      ),
    );
  }
}
