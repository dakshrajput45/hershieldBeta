import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hershield/firebase_options.dart';
import 'package:hershield/router.dart';
import 'package:hershield/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'HerShield',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        routerConfig: routerConfig.getRouter(),
      );
  }
}

