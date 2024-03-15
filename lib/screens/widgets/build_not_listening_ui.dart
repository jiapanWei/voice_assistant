import 'package:flutter/material.dart';

class NotListeningUI extends StatelessWidget {
  const NotListeningUI({super.key});

  @override
  Widget build(BuildContext context) {
    const String ballImagePath = 'images/ball.png';
    const double ballImageSize = 120.0;

    return Image.asset(
      ballImagePath,
      height: ballImageSize,
      width: ballImageSize,
    );
  }
}
