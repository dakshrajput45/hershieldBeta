import 'package:backend_shield/helper/loader.dart';
import 'package:flutter/material.dart';

class SosView extends StatefulWidget {
  const SosView({
    super.key,
  });
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  bool is_loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(
            child: Text("Sos View"),
          ),
          is_loading ? BlurredBackgroundLoader() : const SizedBox.shrink(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  is_loading = !is_loading;
                  print(is_loading);
                });
              },
              child: const Text("Change")),
        ],
      ),
    );
  }
}
