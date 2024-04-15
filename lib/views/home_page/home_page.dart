import 'package:flutter/material.dart';

import '../launches_page/launches_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _SpaceGazeHomePageState();
}

class _SpaceGazeHomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  void _onViewChange(int index) {
    setState(() {
      if (_currentPageIndex != index) {
        // Only animate if the selected tab is different from the current page
        _currentPageIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          controller: _pageController,
          children: const [
            LaunchPage(),
            Center(
              child: Text('space Stations'),
            ),
            Center(
              child: Text('settings'),
            ),
          ],
        ),
        //bottomNavigationBar: spaceGazeBottomNavigationBar(),
      ),
    );
  }
}
