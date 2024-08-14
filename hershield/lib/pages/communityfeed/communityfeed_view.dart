import 'package:flutter/material.dart';
import 'package:hershield/loader.dart';

class CommunityFeedView extends StatefulWidget {
  const CommunityFeedView({
    super.key,
  });
  @override
  State<CommunityFeedView> createState() => _CommunityFeedViewState();
}

class _CommunityFeedViewState extends State<CommunityFeedView> {
    bool is_loading = true;
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Text("community feed")),
          is_loading ? BlurredBackgroundLoader() : SizedBox.shrink(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  is_loading = !is_loading;
                  print(is_loading);
                });
              },
              child: Text("Change")),
        ],
        // child: Text("community feed"),
      ),
    );
  }
}
