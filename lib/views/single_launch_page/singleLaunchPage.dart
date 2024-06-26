import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacegaze_bap_clean/routing/spacegaze_router_constants.dart';
import 'package:spacegaze_bap_clean/views/single_launch_page/ui/widgets/launch_detail_info.dart';

import '../../models/Launch.dart';
import '../../theme/color.dart';

class SingleLaunchPage extends StatelessWidget {
  const SingleLaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Launch launch = GoRouterState.of(context).extra as Launch;
    final String? imageUrl = launch.image;
    return SingleChildScrollView(
      child: Column(
        children: [
          // Custom App Bar
          Container(
            padding: const EdgeInsets.only(
                top: 48.0, left: 8.0, right: 8.0, bottom: 8.0),
            color: Colors
                .black, // Adjust color to match your theme or remove for default theme color.
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    context.goNamed(SpaceGazeRouterConstants.homePage);
                  },
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(launch.rocket.configuration?.name ?? "",
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(launch.mission!.name ?? "",
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
                const Icon(Icons.expand_more_rounded, color: Colors.white),
              ],
            ),
          ),
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: ColorConstants.surfaceGray,
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LaunchDetailInfo(
                          title: "Time", value: launch.net.substring(11, 16)),
                      LaunchDetailInfo(
                          title: "Date", value: launch.net.substring(5, 10)),
                      LaunchDetailInfo(
                          title: "Status", value: launch.status?.abbrev ?? "/"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add to Calendar ",
                              style: Theme.of(context).textTheme.bodyMedium),
                          const Icon(Icons.calendar_today, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text("pad", style: Theme.of(context).textTheme.bodySmall),
                      Text(launch.pad?.name ?? "",
                          style: Theme.of(context).textTheme.bodyLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("View pad location ",
                              style: Theme.of(context).textTheme.bodyMedium),
                          const Icon(Icons.location_on, color: Colors.white),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text("Lsp" ?? "",
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                        launch.lsp?.name ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
