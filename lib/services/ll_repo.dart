import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/Launch.dart';

class LaunchLibraryApi {
  static final LaunchLibraryApi apiService = LaunchLibraryApi._internal();

  final StreamController<List<Launch>> _previousLaunchesController =
      StreamController.broadcast();
  final StreamController<List<Launch>> _upcomingLaunchesController =
      StreamController.broadcast();

  final _baseUrl = "https://lldev.thespacedevs.com/2.2.0/launch";

  factory LaunchLibraryApi.launchLibraryApi() {
    return apiService;
  }

  LaunchLibraryApi._internal();

  void dispose() {
    _previousLaunchesController.close();
    _upcomingLaunchesController.close();
  }

  Stream<List<Launch>> get previousLaunchesStream =>
      _previousLaunchesController.stream;
  Stream<List<Launch>> get upcomingLaunchesStream =>
      _upcomingLaunchesController.stream;

  Future<Launch> getLaunchById(int id) async {
    final url = Uri.parse('$_baseUrl/$id'); // Replace with the actual API URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Launch.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load launch data');
    }
  }

  Future<void> fetchAndUpdatePreviousLaunches() async {
    // todo
    throw UnimplementedError();
  }

  Future<void> fetchAndUpdateUpcomingLaunches() async {
    throw UnimplementedError();
  }
}
