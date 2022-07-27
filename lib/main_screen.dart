import 'package:flutter/material.dart';
import 'package:json_test/image_search_app.dart';
import 'package:json_test/video_search_app.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final screens = [
    const ImageSearchApp(),
    const VideoSearchApp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.photo), label: '이미지'),
          BottomNavigationBarItem(
              icon: Icon(Icons.ondemand_video_outlined), label: '비디오'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xffCC0200),
        onTap: _onItemTapped,
      ),
    );
  }
}
