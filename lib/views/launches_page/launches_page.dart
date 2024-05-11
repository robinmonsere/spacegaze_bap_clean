import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';

import '../../models/Launch.dart';
import '../../services/ll_repo.dart';
import '../../theme/color.dart';
import '../../util/dateFormating.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  LaunchLibraryApi api = LaunchLibraryApi.launchLibraryApi();
  Stream<List<Launch>>? upcomingLaunchesStream;
  Stream<List<Launch>>? previousLaunchesStream;

  final ScrollController _previousScrollController = ScrollController();
  final ScrollController _upcomingScrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _previousScrollController.addListener(() {
      if (_previousScrollController.position.pixels ==
          _previousScrollController.position.maxScrollExtent) {
        loadMorePrevious();
      }
    });
    _upcomingScrollController.addListener(() {
      if (_upcomingScrollController.position.pixels ==
          _upcomingScrollController.position.maxScrollExtent) {
        loadMoreUpcoming();
      }
    });
    // todo: fetch the launches
    upcomingLaunchesStream = api.upcomingLaunchesStream;
    previousLaunchesStream = api.previousLaunchesStream;
  }

  loadMorePrevious() {
    print("loadMorePrevious");
  }

  loadMoreUpcoming() {}

  @override
  Widget build(BuildContext context) {
    print("Building");
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: upcomingLaunchesStream,
            builder: (context, snapshot) {
              print(snapshot.connectionState);
              if (snapshot.connectionState == ConnectionState.waiting) {
                print("Waiting");
                print(snapshot.data);
                // Show loader while waiting for data
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                // Show error if any
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                // Data is received
                List<Launch>? upcomingLaunches = snapshot.data;
                if (upcomingLaunches != null && upcomingLaunches.isNotEmpty) {
                  return upcomingLaunch(upcomingLaunches.first);
                } else {
                  return const Text("No upcoming launches found");
                }
              } else {
                // No data received
                return const Text("Waiting for data...");
              }
            },
          ),
          const Spacer(),
          Text("Next", style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: upcomingLaunchesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loader while waiting for data
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                // Show error if any
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                // Data is received
                List<Launch>? upcomingLaunches = snapshot.data;
                if (upcomingLaunches != null && upcomingLaunches.isNotEmpty) {
                  return scheduledLaunchesWidget(upcomingLaunches.sublist(1));
                } else {
                  return const Text("No upcoming launches found");
                }
              } else {
                // No data received
                return const Text("Waiting for data...");
              }
            },
          ),
          const Spacer(),
          Text("Previous", style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: previousLaunchesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loader while waiting for data
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                // Show error if any
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                // Data is received
                List<Launch>? previousLaunches = snapshot.data;
                if (previousLaunches != null && previousLaunches.isNotEmpty) {
                  return previousLaunchesWidget(previousLaunches);
                } else {
                  return const Text("No previous launches found");
                }
              } else {
                // No data received
                return const Text("Waiting for data...");
              }
            },
          ),
        ],
      ),
    );
  }

  launchBlock(Launch launch) {
    return GestureDetector(
      onTap: () {
        context.go("/launch", extra: launch);
        //context.goNamed("/launch/${launch.id}");
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

  previousLaunchesWidgetLazyLoader(List<Launch> launches) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _previousScrollController,
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return LazyLoadingList(
              loadMore: api.fetchAndUpdatePreviousLaunches,
              child: launchBlock(launches[index]),
              index: index,
              hasMore: true);
        },
      ),
    );
  }

  previousLaunchesWidget(List<Launch> launches) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _previousScrollController,
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: launchBlock(launches[index]),
          );
        },
      ),
    );
  }

  scheduledLaunchesWidget(List<Launch> launches) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        controller: _upcomingScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: launchBlock(launches[index]),
          );
        },
      ),
    );
  }

  upcomingLaunch(Launch launch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(launch.mission!.name ?? "no name provided",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 5,
        ),
        const Row(
          children: [
            Text("More info", style: TextStyle(fontSize: 20)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        // TOdo launch countdown
      ],
    );
  }
}
