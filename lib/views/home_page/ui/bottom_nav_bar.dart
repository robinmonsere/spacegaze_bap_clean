import 'package:flutter/material.dart';

class SpaceGazeBottomNavigationBar extends StatelessWidget {
  final Function onViewChange;
  final int currentPageIndex;

  const SpaceGazeBottomNavigationBar(
      {super.key, required this.onViewChange, required this.currentPageIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) => onViewChange(index),
      currentIndex: currentPageIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(currentPageIndex == 0
              ? Icons.rocket_launch
              : Icons.rocket_launch_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(currentPageIndex == 1
              ? Icons.satellite_alt
              : Icons.satellite_alt_outlined),
          label: 'Space Stations',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              currentPageIndex == 2 ? Icons.settings : Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
