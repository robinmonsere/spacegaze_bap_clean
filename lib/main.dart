import 'package:flutter/material.dart';
import 'package:spacegaze_bap_clean/theme/theme.dart';
import 'package:spacegaze_bap_clean/views/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceGaze Clean',
      theme: SpaceGazeTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
