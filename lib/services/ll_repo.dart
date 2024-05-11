import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

import '../models/Launch.dart';

class LaunchRepository {
  final String _baseUrl = 'https://lldev.thespacedevs.com/2.2.0/launch';
  final BehaviorSubject<List<Launch>> _upcomingLaunchesController =
      BehaviorSubject<List<Launch>>();
  final BehaviorSubject<List<Launch>> _previousLaunchesController =
      BehaviorSubject<List<Launch>>();
  String? _nextUpcomingUrl;
  String? _nextPreviousUrl;

  Stream<List<Launch>> get upcomingLaunchesStream =>
      _upcomingLaunchesController.stream;
  Stream<List<Launch>> get previousLaunchesStream =>
      _previousLaunchesController.stream;

  LaunchRepository() {
    _nextUpcomingUrl = '$_baseUrl/upcoming?limit=5&offset=0&mode=normal';
    _nextPreviousUrl = '$_baseUrl/previous?limit=5&offset=0&mode=normal';
    fetchUpcomingLaunches();
    fetchPreviousLaunches();
  }

  void fetchUpcomingLaunches() async {
    await _fetchLaunches(_nextUpcomingUrl, _upcomingLaunchesController,
        isUpcoming: true);
  }

  void fetchPreviousLaunches() async {
    await _fetchLaunches(_nextPreviousUrl, _previousLaunchesController,
        isUpcoming: false);
  }

  Future<void> _fetchLaunches(
      String? nextUrl, BehaviorSubject<List<Launch>> controller,
      {required bool isUpcoming}) async {
    if (nextUrl == null) {
      return; // No more data to fetch
    }

    final url = Uri.parse(nextUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> launchesJson = json.decode(response.body)['results'];
      String nextUrl = json.decode(response.body)['next'];
      List<Launch> launches =
          launchesJson.map((json) => Launch.fromJson(json)).toList();

      // Update the next URL
      if (isUpcoming) {
        _nextUpcomingUrl = nextUrl;
      } else {
        _nextPreviousUrl = nextUrl;
      }

      // Add new launches to the existing stream
      if (controller.valueOrNull != null) {
        controller.add(controller.valueOrNull!..addAll(launches));
      } else {
        controller.add(launches);
      }
    } else {
      throw Exception('Failed to load launches');
    }
  }

  void dispose() {
    _upcomingLaunchesController.close();
    _previousLaunchesController.close();
  }
}
