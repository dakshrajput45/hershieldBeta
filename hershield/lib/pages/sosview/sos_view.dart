import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/apis/location_api.dart';
import 'package:hershield/helper/loader.dart';
import 'package:hershield/router.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  bool isLoading = false;
  LocationApi locationApi = LocationApi();

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
                      await locationApi.updateUserLocation(
                          lat: 28.682331.toString(),
                          long: 77.4997446.toString(),
                          userId: HSUserAuthSDK.getUser()!.uid);

                      HSUserAuthSDK.signOut();
                      context.goNamed(RouteNames.auth);
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
