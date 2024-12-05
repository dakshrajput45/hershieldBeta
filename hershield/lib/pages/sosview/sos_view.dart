import 'package:backend_shield/helper/loader.dart';
import 'package:flutter/material.dart';

// class SosView extends StatefulWidget {
//   const SosView({
//     super.key,
//   });
//   @override
//   State<SosView> createState() => _SosViewState();
// }

// class _SosViewState extends State<SosView> {
//   bool is_loading = true;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           const Center(
//             child: Text("Sos View"),
//           ),
//           is_loading ? BlurredBackgroundLoader() : const SizedBox.shrink(),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   is_loading = !is_loading;
//                   print(is_loading);
//                 });
//               },
//               child: const Text("Change")),
//         ],
//       ),
//     );
//   }
// }

class EmergencyPage extends StatefulWidget {
  @override
  _EmergencyPageState createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  bool isLoading = false; // Example of dynamic state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'EMERGENCY\nHELP NEEDED?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '(Press the button to notify bystanders and police)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoading = !isLoading;
                      });
                      print('SOS Button Pressed');
                    },
                    child: Image.asset(
                      '', // Add Sos Image here 
                      height: 150, 
                    ),
                  ),
                  SizedBox(height: 20),
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
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(), // loading spinner
                ),
            ],
          ),
        ),
      ),
    );
  }
}