import 'package:go_router/go_router.dart';
import 'package:hershield/pages/areaprofiling/areaprofiling_view.dart';
import 'package:hershield/pages/auth/forgetpassword_view.dart';
import 'package:hershield/pages/auth/login_view.dart';
import 'package:hershield/pages/auth/otp_view.dart';
import 'package:hershield/pages/auth/signup_view.dart';
import 'package:hershield/pages/communityfeed/communityfeed_view.dart';
import 'package:hershield/pages/home_view.dart';
import 'package:hershield/pages/sosview/sos_view.dart';
import 'package:hershield/pages/userprofile/userprofile_view.dart';

// Simulate login status
int isLoggedIn = 2;
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
        path: '/login',
        name: routeNames.login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/signup',
        name: routeNames.signup,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: '/otp',
        name: routeNames.otp,
        builder: (context, state) => const OtpView(),
      ),
      GoRoute(
        path: '/forgetpassword',
        name: routeNames.forgetpassword,
        builder: (context, state) => const ForgetPasswordView(),
      ),
      // StatefulShellRoute for authenticated routes
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
        return ("/login");
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
  final String login = 'login';
  final String signup = 'signup';
  final String otp = 'otp';
  final String forgetpassword = 'forgetpassword';
}
