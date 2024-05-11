import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacegaze_bap_clean/routing/spacegaze_router_constants.dart';

import '../../../../models/Launch.dart';

class UpcomingLaunch extends StatelessWidget {
  const UpcomingLaunch({super.key, required this.launch});

  final Launch launch;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(launch.mission!.name ?? "no name provided",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            context.goNamed(SpaceGazeRouterConstants.singleLaunchPage,
                extra: launch);
          },
          child: const Row(
            children: [
              Text("More info", style: TextStyle(fontSize: 20)),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        // Todo launch countdown
      ],
    );
  }
}
