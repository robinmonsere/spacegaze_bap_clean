import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/Launch.dart';
import '../../../../routing/spacegaze_router_constants.dart';
import '../../../../theme/color.dart';
import '../../../../util/dateFormating.dart';

class LaunchBlock extends StatelessWidget {
  final Launch launch;

  const LaunchBlock({super.key, required this.launch});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(SpaceGazeRouterConstants.singleLaunchPage,
            extra: launch);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            image: DecorationImage(
                image: NetworkImage(launch.image ?? ""), fit: BoxFit.cover),
            border: Border.all(color: ColorConstants.accentColor),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        width: 250,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(launch.mission!.name ?? "no name provided",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text(launch.lsp?.name ?? ""),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatDateToDayMonth(launch.net)),
                      Text(formatDateToHourMinute(launch.net))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
