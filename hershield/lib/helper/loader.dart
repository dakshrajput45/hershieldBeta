import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BlurredBackgroundLoader extends StatelessWidget {
  const BlurredBackgroundLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            color: Colors.white, // Optional dark overlay
          ),
        ),
        // Centered Loader
        const Center(
          child: SpinKitWaveSpinner(
            color: Color(0xFF6C4AB6),
            size: 100,
            curve: Curves.linearToEaseOut,
          ),
        ),
      ],
    );
  }
}
