import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hershield/firebase_options.dart';
import 'package:hershield/helper/log.dart';
import 'package:hershield/router.dart';
import 'package:hershield/theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  hsLog("Work Manager is working!!");

  Workmanager().executeTask((task, inputData) async {
    try {
      hsLog("Background Task Triggered: $task");

      // Call the method to get the background location
      startBackgroundLocator();

      // Log when location is fetched
      hsLog("Location fetched in background task");
    } catch (e) {
      hsLog("Error in background task: $e");
    }

    return Future.value(true);
  });
}

void startBackgroundLocator() {
  try {
    hsLog("Starting Background Locator...");

    BackgroundLocator.registerLocationUpdate(
      locationCallback,
      androidSettings: const AndroidSettings(
        accuracy: LocationAccuracy.LOW, // Low accuracy for background fetching
        interval: 10000, // Location updates every 10 seconds
        distanceFilter: 0, // No distance filter
      ),
    );
    hsLog("Background Locator started successfully");
  } catch (e) {
    hsLog("Error starting background locator: $e");
  }
}

void locationCallback(LocationDto locationDto) {
  // This callback will be triggered every time the location is updated in the background
  hsLog("...............................................................");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("Background Location Updated: Latitude: ${locationDto.latitude}, Longitude: ${locationDto.longitude}");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("");
  hsLog("...........................................................");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Workmanager().initialize(
    callbackDispatcher, // The background task handler
    isInDebugMode: true, // Enable logs in debug mode
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp.router(
            title: 'HerShield',
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            routerConfig: GNRouteConfig.router,
          );
        },
      ),
    );
  }
}
