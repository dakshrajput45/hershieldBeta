import 'package:flutter/material.dart';
import 'package:hershield/helper/loader.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/services/location.dart';
import 'package:location/location.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const BlurredBackgroundLoader()
        : Scaffold(
            backgroundColor: Theme.of(context)
                .colorScheme
                .onTertiary, // Set the background color
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logoShield.png',
                    height: 150,
                  ),
                  const Text(
                    'EMERGENCY\nHELP NEEDED?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '(Press the button to notify bystanders and police)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), elevation: 10),
                    onPressed: () async {
                      hsLog('SOS Button Pressed');
                      LocationData? locData = await getForegroundLocation();
                      hsLog("location data:- ${locData?.latitude}");
                    },
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/sosButton.jpg', // Add Sos Image here
                        height: 180,
                        width: 180,
                        fit: BoxFit
                            .cover, // Ensures the image fills the button properly
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Help is just a moment away!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
