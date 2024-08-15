import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BlurredBackgroundLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            color: Colors.white.withOpacity(0.3), // Optional dark overlay
          ),
        ),
        // Centered Loader
        const Center(
          child: SpinKitWaveSpinner(
            color: Colors.pink,
            size: 100,
            curve: Curves.linearToEaseOut,
          ),
        ),
      ],
    );
  }
}
