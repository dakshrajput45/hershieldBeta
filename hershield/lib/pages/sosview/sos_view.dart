import 'package:flutter/material.dart';

class SosView extends StatefulWidget {
  const SosView({
    super.key,
  });
  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("Sos View"),
    ));
  }
}
