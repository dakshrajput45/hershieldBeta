import 'package:flutter/material.dart';

class AreaProfilingView extends StatefulWidget {
  const AreaProfilingView({
    super.key,
  });
  @override
  State<AreaProfilingView> createState() => _AreaProfilingViewState();
}

class _AreaProfilingViewState extends State<AreaProfilingView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text("area profiling"),
    ));
  }
}
