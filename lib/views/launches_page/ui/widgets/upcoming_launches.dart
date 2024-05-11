import 'package:flutter/cupertino.dart';

import '../../../../models/Launch.dart';
import 'launch_block.dart';

class UpcomingLaunches extends StatelessWidget {
  const UpcomingLaunches(
      {super.key,
      required this.launches,
      required this.upcomingScrollController});

  final List<Launch> launches;
  final ScrollController upcomingScrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: upcomingScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: LaunchBlock(launch: launches[index]),
          );
        },
      ),
    );
  }
}
