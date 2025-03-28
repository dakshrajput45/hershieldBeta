import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/pages/home_controller.dart';
import 'package:hershield/router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({super.key});

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      body: CustomPaint(
        painter: PolkaDotPainter(),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .center, // Ensure everything is centered horizontally
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 120, bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Set shape to circle
                        color: Colors.grey.shade200,
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: CachedNetworkImage(
                        imageUrl:
                            HSProfileController.getProfile()?.profileImage ??
                                " ", // Add user's profile image URL
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              // Username text
              Text(
                HSProfileController.getProfile()?.name ??
                    "Guest User", // Default text if null
                style: TextStyle(
                  fontSize: 2.8.sh,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
              // Buttons below the text
              const SizedBox(height: 30), // Space between text and buttons
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Space buttons evenly
                children: [
                  // Edit Profile button
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      context.goNamed(RouteNames.onboard);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary, // Dark purple color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.2.sh,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      context.pushNamed(RouteNames.emergency);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary, // Dark purple color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      'Emergency no.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.sh,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // List of options
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Protector Mode ListTile
                    ListTile(
                      leading: const Icon(Icons.security, color: Colors.black),
                      title: const Text('Protector Mode'),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    const Divider(thickness: 1), // Add bottom line
                    // Recent Alerts ListTile
                    ListTile(
                      leading:
                          const Icon(Icons.notifications, color: Colors.black),
                      title: const Text('Recent Alerts'),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    const Divider(thickness: 1), // Add bottom line
                    // Settings ListTile
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.black),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.black),
                      onTap: () {
                        // Handle tap
                      },
                    ),
                    const Divider(thickness: 1), // Add bottom line

                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.red),
                      onTap: () {
                        // Handle tap
                        HSUserAuthSDK.signOut();
                        context.goNamed(RouteNames.auth);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PolkaDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD6A5E5) // The background circle color
      ..style = PaintingStyle.fill;

    double y = -45.sh; // Adjust vertical position of the circle
    double x = size.width / 2;
    canvas.drawCircle(Offset(x, y), 82.sh, paint); // Draw circle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
