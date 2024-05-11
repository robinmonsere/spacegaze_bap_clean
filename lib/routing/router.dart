import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spacegaze_bap_clean/routing/spacegaze_router_constants.dart';

import '../views/home_page/home_page.dart';
import '../views/single_launch_page/singleLaunchPage.dart';

class SpaceGazeRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
        name: SpaceGazeRouterConstants.homePage,
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HomePage(),
          );
        }),
    GoRoute(
        name: SpaceGazeRouterConstants.singleLaunchPage,
        path: '/launch',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SingleLaunchPage(),
          );
        }),
  ]);
  //redirect: (context, GoRouterState state) async {
  //  return "/";
  //});
}
