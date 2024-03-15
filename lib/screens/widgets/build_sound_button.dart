import 'package:flutter/material.dart';

class SoundButton extends StatelessWidget {
  final bool speakAI;
  final bool isLoading;
  final VoidCallback onPressed;

  const SoundButton({
    super.key,
    required this.speakAI,
    required this.isLoading,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context){
        const double iconSize = 20.0;
    const double containerSize = 40.0;
    const double paddingRight = 16.0;
    const double paddingBottom = 32.0;

    const List<Color> gradientColors = [
      Color.fromARGB(255, 242, 201, 249),
      Color.fromARGB(255, 255, 238, 252),
    ];

    const String speakerIconPath = "images/speaker_icon.png";
    const String muteIconPath = "images/mute_icon.png";

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: paddingRight, bottom: paddingBottom),
        child: SizedBox(
          width: containerSize,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: FloatingActionButton(
              onPressed: onPressed,
              shape: const CircleBorder(),
              foregroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              child: Image.asset(
                speakAI ? speakerIconPath : muteIconPath,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

