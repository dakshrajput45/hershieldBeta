import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hershield/apis/auth/user_auth.dart';
import 'package:hershield/helper/loader.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/pages/home_controller.dart';
import 'package:hershield/router.dart';
import 'package:hershield/services/location.dart';
import 'package:hershield/services/user_permission.dart';
import 'package:hershield/widget/location_permission_view.dart';
import 'package:workmanager/workmanager.dart';

class HomeView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final int index;

  const HomeView(
      {super.key, required this.navigationShell, required this.index});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    serviceShield();
    super.initState();
  }

  Future<void> serviceShield() async {
    await _getUserProfile();
    await askLocation();
    registerBackgroundTask();
    getForegroundLocation();
  }

  Future<void> askLocation() async {
    try {
      await isLocationAlwaysGranted()
          ? hsLog("location permission is granted")
          : showLocationPermissionDialog(context);
    } catch (e) {
      hsLog("Error Asking location: $e");
    }
  }

  void registerBackgroundTask() {
    hsLog('request backgorund task working!!');
    Workmanager().registerPeriodicTask(
      "fetchLocationTask",
      "fetchLocation",
      frequency: const Duration(minutes: 15), // Every 2 hours
      initialDelay: const Duration(seconds: 10),
    );
    hsLog("Task regsitered");
  }

  Future<void> _getUserProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      hsLog("Fetching user by authid");
      // login api
      var user = await HSProfileController.fetchUser(
          userId: HSUserAuthSDK.getUser()!.uid);

      hsLog("user at home: ${user?.toJson()}");

      /// register new user
      if (user == null) {
        context.goNamed(
          RouteNames.onboard,
          extra: true,
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      hsLog("Error fetching user profile: $e");
      // "Error fetching user profile: $e".showAsErrorPopup(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const BlurredBackgroundLoader()
        : Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: const Text(
                'HerShield',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: widget.navigationShell, // Display the current page
            bottomNavigationBar: BottomNavigationBar(
              elevation: 4,
              backgroundColor: Theme.of(context).colorScheme.primary,
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white, // Light color for selected icon
              unselectedItemColor:
                  Colors.white, // Light gray for unselected icon
              onTap: (page) {
                setState(() {
                  _selectedIndex = page;
                  switch (page) {
                    case 0:
                      context.goNamed(RouteNames.sos);
                      break;
                    case 1:
                      context.goNamed(RouteNames.userprofile);
                      break;
                    default:
                      break;
                  }
                });
              },
              items: const [
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.home_max_rounded),
                  icon: Icon(Icons.home_max_outlined),
                  label: 'Sos',
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            ),
          );
  }
}
