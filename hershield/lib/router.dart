import 'package:go_router/go_router.dart';
import 'package:hershield/pages/areaprofiling/areaprofiling_view.dart';
import 'package:hershield/pages/auth/auth_view.dart';
import 'package:hershield/pages/communityfeed/communityfeed_view.dart';
import 'package:hershield/pages/home_view.dart';
import 'package:hershield/pages/sosview/sos_view.dart';
import 'package:hershield/pages/userprofile/userprofile_view.dart';

// Simulate login status
int isLoggedIn = 1;
void updateLoginStatus(int loggedIn) {
  isLoggedIn = loggedIn;
}

RouterConfig routerConfig = RouterConfig();
RouteNames routeNames = RouteNames();

class RouterConfig {
  GoRouter getRouter() => _router;
  final GoRouter _router = GoRouter(
    // Define routes
    routes: [
      GoRoute(
        path: '/auth',
        name: routeNames.auth,
        builder: (context, state) => const AuthView(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeView(
            navigationShell: navigationShell,
            title: 'hershield',
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: routeNames.sos,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SosView()),
              ),
              GoRoute(
                path: '/communityfeed',
                name: routeNames.communityfeed,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: CommunityFeedView()),
              ),
              GoRoute(
                path: '/areaprofiling',
                name: routeNames.areaprofiling,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: AreaProfilingView()),
              ),
              GoRoute(
                path: '/userprofile',
                name: routeNames.userprofile,
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: UserProfileView()),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (isLoggedIn == 1) {
        return ("/auth");
      }
      return null;
    },
  );
}

class RouteNames {
  final String sos = 'sos';
  final String areaprofiling = 'areaprofiling';
  final String communityfeed = 'communityfeed';
  final String userprofile = 'userprofile';
  final String auth = 'auth';
}
