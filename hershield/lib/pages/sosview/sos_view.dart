import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/apis/sos_api.dart';
import 'package:hershield/helper/loader_sos.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/models/safe_places_model.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  bool isLoading = false;
  SosApi sosApi = SosApi();
  int nearbyUsers = 0;
  List<HSSafePlace> safePlaces = [];
  String directionsUrl = "";

  Future<int> _fetchNearbyUsers() async {
    try {
      return await sosApi.findNearByUser(
        userId: HSUserAuthSDK.getUser()!.uid,
      );
    } catch (e) {
      return 0;
    }
  }

  Future<void> _fetchSafePlaces() async {
    try {
      SafePlacesResult result = await sosApi.findNearBySafePlaces(
        userId: HSUserAuthSDK.getUser()!.uid,
      );

      if (result.places != null) {
        setState(() {
          safePlaces = result.places!;
          directionsUrl = result.directionsUrl!; // Store the directions URL
        });
      }
    } catch (e) {
      hsLog("Error fetching safe places: $e");
    }
  }

  void _showResultDialog(int nearbyUsers) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            nearbyUsers > 0
                ? 'We have found $nearbyUsers people nearby and have notified them.\nStay calm, help is just a moment away! 💙'
                : 'Unfortunately, we couldn’t find any nearby users at the moment. Please try again later and be safe!!',
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSafePlacesDialog(); // Show safe places after closing first dialog
              },
              child: const Text(
                'OK, Show Safe Places',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF6C4AB6)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSafePlacesDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Safe Places Nearby",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite, // Ensures proper width
            child: SingleChildScrollView(
              // Makes it scrollable
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (safePlaces.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        children: [
                          Text(
                            "We have found some nearest safe places for you. Tap to see the locations. Be safe!",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Help is just moments away 💙",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),

                    // 📌 Directions URL (Top)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6.0, vertical: 2.0),
                      title: const Text(
                        "Best Route to Safe Places",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: const Text(
                        "Tap to open directions.",
                        style: TextStyle(fontSize: 12),
                      ),
                      leading: Icon(Icons.directions,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24),
                      onTap: () async {
                        await FlutterWebBrowser.openWebPage(url: directionsUrl);
                      },
                    ),

                    const Divider(),

                    // 📌 Individual Safe Places
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.0),
                      child: Text(
                        "Individual safe locations",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 2),

                    ...safePlaces.map(
                      (place) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 0.0),
                        title: Text(
                          place.name ?? 'Unknown',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${place.type} - ${place.distance} km away",
                          style: const TextStyle(fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Icon(Icons.location_pin,
                            color: Theme.of(context).colorScheme.primary,
                            size: 22),
                        onTap: () async {
                          String url =
                              'https://www.google.com/maps?q=${place.lat},${place.lon}';
                          await FlutterWebBrowser.openWebPage(
                              url: place.mapsUrl ?? url);
                        },
                      ),
                    ),
                  ] else ...[
                    // 📌 No Safe Places Found
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                      child: Text(
                        "No safe places found. Stay strong! 💙",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "OK, Thank You!",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Color(0xFF6C4AB6)),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logoShield.png',
                  height: 200,
                ),
                const Text(
                  'EMERGENCY\nHELP NEEDED?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
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
                      shape: const CircleBorder(), elevation: 10),
                  onPressed: () async {
                    setState(() => isLoading = true);
                    nearbyUsers = await _fetchNearbyUsers();
                    _showResultDialog(nearbyUsers);
                    await _fetchSafePlaces();
                    setState(() => isLoading = false);
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
          if (isLoading) const BlurredBackgroundLoaderSOS(),
        ],
      ),
    );
  }
}
