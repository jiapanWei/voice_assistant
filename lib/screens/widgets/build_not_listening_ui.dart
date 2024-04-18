import 'package:flutter/material.dart';

// Define NotListeningUI widget
class NotListeningUI extends StatelessWidget {
  const NotListeningUI({super.key});

  // Build the NotListeningUI widget
  @override
  Widget build(BuildContext context) {
    const String ballImagePath = 'images/ball.png';
    const double ballImageSize = 120.0;

    // Return the image of the ball
    return Image.asset(
      ballImagePath,
      height: ballImageSize,
      width: ballImageSize,
    );
  }
}
