
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/pages/auth/auth_view.dart';
import 'package:hershield/pages/home_view.dart';
import 'package:hershield/pages/sosview/sos_view.dart';
import 'package:hershield/pages/userprofile/emergency_contact.dart';
import 'package:hershield/pages/userprofile/onboard_form.dart';
import 'package:hershield/pages/userprofile/userprofile_view.dart';

// Simulate login status
int isLoggedIn = 1;
void updateLoginStatus(int loggedIn) {
  isLoggedIn = loggedIn;
}

class GNRouteConfig {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/",
    routes: [
      StatefulShellRoute.indexedStack(
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: RouteNames.sos,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SosView()),
              ),
              GoRoute(
                path: '/userprofile',
                name: RouteNames.userprofile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserProfileView()),
              ),
            ],
          ),
        ],
        builder: (context, state, navigationShell) {
          int index = 0;
          switch (state.fullPath) {
            case '/userprofile':
              index = 1;
              break;
          }
          return HomeView(
            navigationShell: navigationShell,
            index: index,
          );
        },
      ),
      GoRoute(
        path: '/auth',
        name: RouteNames.auth,
        builder: (context, state) => const AuthView(),
      ),
      GoRoute(
        path: '/onboard',
        name: RouteNames.onboard,
        builder: (context, state) => const OnboardingFormView(),
      ),
      GoRoute(
        path: '/emergency',
        name: RouteNames.emergency,
        builder: (context, state) => const EmergencyContactForm(),
      )
    ],
    redirect: (context, state) {
      if (HSUserAuthSDK.getUser() == null) {
        var allowedLocations = ["/auth"];
        if (allowedLocations.contains(state.matchedLocation)) {
          return null;
        }
        hsLog(state.matchedLocation);
        return "/auth";
      }
      return null;
    },
  );

  // GoRoute(
  //   path: '/communityfeed',
  //   name: routeNames.communityfeed,
  //   pageBuilder: (context, state) =>
  //       const NoTransitionPage(child: CommunityFeedView()),
  // ),
  // GoRoute(
  //   path: '/areaprofiling',
  //   name: routeNames.areaprofiling,
  //   pageBuilder: (context, state) =>
  //       const NoTransitionPage(child: AreaProfilingView()),
  // ),
  static GoRouter get router => _router;
}

class RouteNames {
  static const String sos = 'sos';
  static const String areaprofiling = 'areaprofiling';
  static const String communityfeed = 'communityfeed';
  static const String userprofile = 'userprofile';
  static const String auth = 'auth';
  static const String onboard = 'onbaord';
  static const String emergency = 'emergency';
}
