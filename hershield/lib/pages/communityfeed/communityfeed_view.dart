import 'package:flutter/material.dart';

class CommunityFeedView extends StatefulWidget {
  const CommunityFeedView({
    super.key,
  });
  @override
  State<CommunityFeedView> createState() => _CommunityFeedViewState();
}

class _CommunityFeedViewState extends State<CommunityFeedView> {
  

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("community feed"),
      ),
    );
  }
}
