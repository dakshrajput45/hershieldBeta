import 'package:flutter/material.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/apis/sos_api.dart';
import 'package:hershield/helper/loader_sos.dart';
import 'package:hershield/models/user_model.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  bool isLoading = false; // Loading state for API call
  SosApi sosApi = SosApi();
  int nearbyUsers = 0;

  Future<int> _fetchNearbyUsers() async {
    try {
      final List<HSUser>? users = await sosApi.findNearByUser(
        userId: HSUserAuthSDK.getUser()!.uid,
      );
      return users?.length ?? 0;
    } catch (e) {
      // In case of an error, return 0 users
      return 0;
    }
  }

  void _showResultDialog(int nearbyUsers) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 2.0), // Reduced vertical padding
            child: Text(
              nearbyUsers > 0
                  ? 'We have found $nearbyUsers people nearby and have notified them.\nStay calm, help is just a moment away! 💙'
                  : 'Unfortunately, we couldn’t find any nearby users at the moment. Please try again later and be safe!!',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.justify, // Justify text alignment
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK, Thank you!',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6C4AB6), // Calm purple tone
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      body: Stack(
        children: [
          // Main content
          Padding(
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
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    elevation: 10,
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // Set loading state to true
                    });

                    // Fetch nearby users
                    nearbyUsers = await _fetchNearbyUsers();

                    // Show result dialog after the fetching is complete
                    _showResultDialog(nearbyUsers);

                    setState(() {
                      isLoading = false; // Set loading state to false
                    });
                  },
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/sosButton.jpg',
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Help is just a moment away!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          // Show loader when `isLoading` is true
          if (isLoading) const BlurredBackgroundLoaderSOS(),
        ],
      ),
    );
  }
}
