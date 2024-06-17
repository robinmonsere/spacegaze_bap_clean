import '../models/Launch.dart';

abstract class LaunchRepositoryInterface {

  Stream<List<Launch>> get upcomingLaunchesStream;
  Stream<List<Launch>> get previousLaunchesStream;

  void fetchUpcomingLaunches();
  void fetchPreviousLaunches();
  void dispose();
}
