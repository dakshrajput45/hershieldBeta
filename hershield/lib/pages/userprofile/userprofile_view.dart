import 'package:flutter/material.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({
    super.key,
  });
  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("user profile"),
    ));
  }
}