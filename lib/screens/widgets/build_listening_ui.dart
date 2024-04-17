import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:logger/logger.dart';
import 'package:voice_assistant/screens/widgets/build_logger_style.dart';

class ListeningUI extends StatefulWidget {
  final bool isLoading;
  final bool showCloseButton;
  final VoidCallback stopListeningNow;
  final SpeechToText speechToTextInstance;

  const ListeningUI({
    super.key,
    required this.isLoading,
    required this.showCloseButton,
    required this.stopListeningNow,
    required this.speechToTextInstance,
  });

  @override
  ListeningUIState createState() => ListeningUIState();
}

class ListeningUIState extends State<ListeningUI> {
  bool isListening = false;
  final Logger logger = LoggerStyle.getLogger();

  @override
  void initState() {
    super.initState();
    isListening = widget.speechToTextInstance.isListening;
    widget.speechToTextInstance.statusListener = (status) {
      setState(() {
        isListening = status.toString().toLowerCase().contains('listening');
        logger.i('Listening status: $isListening');
      });
    };
  }

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
          isListening
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
          if (isListening)
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
                    onPressed: widget.stopListeningNow,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
