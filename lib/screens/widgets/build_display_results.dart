import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_assistant/screens/widgets/display_default_text.dart';
import 'package:voice_assistant/screens/widgets/display_result_image.dart';

class DisplayResult extends StatelessWidget {
  final String modeOfAI;
  final String answerTextFromAI;
  final String imageUrlFromAI;
  final bool isDownloadComplete;
  final Function(String) getPublicDirectoryPath;

  const DisplayResult({
    super.key,
    required this.modeOfAI,
    required this.answerTextFromAI,
    required this.imageUrlFromAI,
    required this.isDownloadComplete,
    required this.getPublicDirectoryPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        modeOfAI == "chat"
            ? answerTextFromAI.isNotEmpty
                ? SelectableText(
                    answerTextFromAI,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      color: const Color.fromARGB(255, 101, 100, 100),
                    ),
                  )
                : RichText(
                    text: const TextSpan(
                      children: [
                        WidgetSpan(
                          child: DisplayResultRichText(
                            text: '\nHi there! I\'m MiMi, an AI assistant created by Amy and Hailey.\n\nI\'m here to help you with all sorts of tasks and make your day a little brighter! \n\nTo get started, just tap on the center microphone ball and say something.',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
            : modeOfAI == "images"
                ? imageUrlFromAI.isNotEmpty
                    ? SizedBox(
                        width: 225,
                        child: Column(
                          children: [
                           DisplayResultImage(imageUrlFromAI: imageUrlFromAI, getPublicDirectoryPath: getPublicDirectoryPath),
                          ],
                        ),
                      )
                    : SizedBox(
                        width: 230,
                        child: LottieBuilder.asset(
                          'images/image_animation.json',
                          width: 200,
                          height: 200,
                        ),
                      )
                : modeOfAI == ""
                    ? RichText(
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              child: DisplayResultRichText(
                                text: '\nHi there! I\'m MiMi, an AI assistant created by Amy and Hailey.\n\nI\'m here to help you with all sorts of tasks and make your day a little brighter! \n\nTo get started, just tap on the center microphone ball and say something.',
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
      ],
    );
  }
}
