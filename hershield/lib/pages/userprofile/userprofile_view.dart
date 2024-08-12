import 'package:flutter/material.dart';
import 'package:backend_shield/apis/auth/user_auth.dart';
import 'package:go_router/go_router.dart';
// import 'package:hershield/pages/auth/auth_view.dart';
// import 'package:hershield/pages/home_view.dart';
import 'package:hershield/router.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({
    super.key,
  });
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final HSUserAuthSDK _hsUserAuthSDK = HSUserAuthSDK();

  void handleLogin(int val) {
    updateLoginStatus(val); // Update isLoggedIn to true
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "User Profile",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
        SizedBox(
          height: 16,
        ),
        ElevatedButton(
            child: Text("Sign Out"),
            onPressed: () async {
              _hsUserAuthSDK.signOut();
              handleLogin(1);
              context.goNamed(routeNames.auth);
            }),
      ],
    );
  }
}
