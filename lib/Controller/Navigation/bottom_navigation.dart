import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (i) {
        //debugPrint('$i');
        setState(() {
          _currentIndex = i;
        });
      },
      items: [
        /// Home
        SalomonBottomBarItem(
          icon: const Icon(Ionicons.apps_outline),
          title: const Text("Explore"),
          selectedColor: Colors.blue,
        ),

        ///speak

        SalomonBottomBarItem(
          icon: const Icon(Ionicons.home_outline),
          title: const Text("Home"),
          selectedColor: Colors.teal,
        ),

        /// Likes
        SalomonBottomBarItem(
          icon: const Icon(Ionicons.archive_outline),
          title: const Text("Saved"),
          selectedColor: Colors.pink,
        ),
      ],
    );
  }
}
