import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BlurredBackgroundLoaderSOS extends StatelessWidget {
  const BlurredBackgroundLoaderSOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            color: Colors.white, // Optional dark overlay with some transparency
          ),
        ),
        // Centered Loader and Text
        const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitWaveSpinner(
                color: Color(0xFF6C4AB6),
                size: 100,
                curve: Curves.linearToEaseOut,
              ),
              SizedBox(height: 20), // Add some space between the spinner and text
              Text(
                "We are finding nearby users for you.\nStay safe!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
