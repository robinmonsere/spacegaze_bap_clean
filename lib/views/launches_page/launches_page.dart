import 'package:flutter/material.dart';
import 'package:spacegaze_bap_clean/views/launches_page/ui/widgets/upcoming_launches.dart';

import '../../models/Launch.dart';
import '../../services/ll_repo.dart';
import 'ui/widgets/previous_launches.dart';
import 'ui/widgets/upcoming_launch.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  late final LaunchRepository _repository;

  late final ScrollController _previousScrollController;
  late final ScrollController _upcomingScrollController;

  @override
  void dispose() {
    _previousScrollController.removeListener(_onScrollPrevious);
    _upcomingScrollController.removeListener(_onScrollUpcoming);
    _previousScrollController.dispose();
    _upcomingScrollController.dispose();
    _repository.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _repository = LaunchRepository();
    _previousScrollController = ScrollController();
    _upcomingScrollController = ScrollController();

    _previousScrollController.addListener(_onScrollPrevious);
    _upcomingScrollController.addListener(_onScrollUpcoming);
  }

  void _onScrollPrevious() {
    if (_previousScrollController.position.pixels ==
        _previousScrollController.position.maxScrollExtent) {
      _repository.fetchPreviousLaunches();
    }
  }

  void _onScrollUpcoming() {
    if (_upcomingScrollController.position.pixels ==
        _upcomingScrollController.position.maxScrollExtent) {
      _repository.fetchUpcomingLaunches();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height - 150),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Next", style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(
                height: 5,
              ),
              StreamBuilder(
                stream: LaunchRepository().upcomingLaunchesStream,
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
                    if (upcomingLaunches != null &&
                        upcomingLaunches.isNotEmpty) {
                      return UpcomingLaunch(launch: upcomingLaunches.first);
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
              Text("Upcoming",
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _repository.upcomingLaunchesStream,
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
                    if (upcomingLaunches != null &&
                        upcomingLaunches.isNotEmpty) {
                      return UpcomingLaunches(
                          launches: upcomingLaunches.sublist(1),
                          upcomingScrollController: _upcomingScrollController);
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
              Text("Previous",
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: _repository.previousLaunchesStream,
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
                    if (previousLaunches != null &&
                        previousLaunches.isNotEmpty) {
                      return PreviousLaunches(
                          launches: previousLaunches,
                          previousScrollController: _previousScrollController);
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
        ),
      ),
    );
  }
}
