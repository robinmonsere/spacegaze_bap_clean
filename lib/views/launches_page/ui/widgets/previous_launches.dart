import 'package:flutter/cupertino.dart';

import '../../../../models/Launch.dart';
import 'launch_block.dart';

class PreviousLaunches extends StatelessWidget {
  const PreviousLaunches({
    super.key,
    required this.launches,
    required this.previousScrollController,
  });

  final List<Launch> launches;
  final ScrollController previousScrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: previousScrollController,
        reverse: true,
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
