import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ListeningUI extends StatelessWidget {
  final bool isLoading;
  final bool showCloseButton;
  final VoidCallback stopListeningNow;

  const ListeningUI({
    super.key,
    required this.isLoading,
    required this.showCloseButton,
    required this.stopListeningNow,
  });

  @override
  Widget build(BuildContext context) {
    const String ballAnimationPath = 'images/ball_animation.json';
    const String ballImagePath = 'images/ball.png';
    const double ballAnimationSize = 200.0;
    const double ballImageSize = 120.0;
    const double closeButtonSize = 40.0;
    const double closeButtonScale = 0.75;

    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          isLoading
              ? LottieBuilder.asset(
                  ballAnimationPath,
                  width: ballAnimationSize,
                  height: ballAnimationSize,
                )
              : Image.asset(
                  ballImagePath,
                  height: ballImageSize,
                  width: ballImageSize,
                ),
          if (showCloseButton)
            Positioned(
              top: 10,
              right: 10,
              child: SizedBox(
                width: closeButtonSize,
                height: closeButtonSize,
                child: Transform.scale(
                  scale: closeButtonScale,
                  child: CloseButton(
                    color: Colors.grey,
                    onPressed: stopListeningNow,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
