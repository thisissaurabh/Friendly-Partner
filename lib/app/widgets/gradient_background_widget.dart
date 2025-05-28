import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFFFFF), //
            Color(0xFFB0B0E0), // Slightly darker purple/grey (bottom)
          ],
        ),
      ),
      child: child,
    );
  }
}
