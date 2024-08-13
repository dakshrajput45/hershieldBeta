import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


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
    return Scaffold(
        body: Center(
      child: SpinKitWaveSpinner(
        color: Colors.pink,
        size: 100,
        curve: Curves.decelerate,
      ),
      // child: Text("community feed"),
    ));
  }
}
