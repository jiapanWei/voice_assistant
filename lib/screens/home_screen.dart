import "dart:convert";
import "dart:io";
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:flutter_downloader/flutter_downloader.dart";
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";
import "package:voice_assistant/api/api_service.dart";
import 'package:text_to_speech/text_to_speech.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

import 'package:voice_assistant/screens/widgets/change_avatar.dart';
import 'package:voice_assistant/screens/widgets/build_logger_style.dart';
import 'package:voice_assistant/screens/widgets/build_display_results.dart';
import 'package:voice_assistant/screens/widgets/build_listening_ui.dart';
import 'package:voice_assistant/screens/widgets/build_mode_button.dart';
import 'package:voice_assistant/screens/widgets/build_not_listening_ui.dart';
import 'package:voice_assistant/screens/widgets/build_sound_button.dart';
import 'package:voice_assistant/screens/widgets/build_text_input_field.dart';

// Define HomeScreen Widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Define HomeScreen state
class _HomeScreenState extends State<HomeScreen> {
  // Get the current user from Firebase Authentication
  final currentUser = FirebaseAuth.instance.currentUser!;

  final changeUserAvatar = ChangeUserAvatar();
  final Logger logger = LoggerStyle.getLogger();

  // Initialize text editing controller for user input
  TextEditingController userInputTextEditingController = TextEditingController();

  // Create an instance of SpeechToText
  final SpeechToText speechToTextInstance = SpeechToText();

  // Initialize varibles
  String recordedAudioString = "";
  bool isLoading = false;
  bool showCloseButton = false;

  String modeOfAI = "chat";
  String imageUrlFromAI = "";
  String answerTextFromAI = "";
  bool isDownloadComplete = false;

  bool speakAI = true;
  final TextToSpeech textToSpeechInstance = TextToSpeech();

  // Initialize SpeechToText instance
  void initializeSpeechToText() async {
    await speechToTextInstance.initialize();
    setState(() {});
  }

  // Start listening for speech
  void startListeningNow() async {
    FocusScope.of(context).unfocus();

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      isLoading = true;
      showCloseButton = true;
    });

    logger.i('Before: ${speechToTextInstance.isListening}');

    await speechToTextInstance.listen(onResult: onSpeechToTextResult);

    logger.i('After: ${speechToTextInstance.isListening}');
  }

  // Stop listening for speech
  void stopListeningNow() async {
    await speechToTextInstance.stop();

    setState(() {
      isLoading = false;
      showCloseButton = false;
    });
  }

  // Handle speech recognition result
  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    logger.i('onSpeechToTextResult called');
    logger.i('recognitionResult.recognizedWords: ${recognitionResult.recognizedWords}');
    logger.i('recognitionResult.finalResult: ${recognitionResult.finalResult}');
    recordedAudioString = recognitionResult.recognizedWords;

    if (!speechToTextInstance.isListening) {
      sendRequestToOpenAI(recordedAudioString);
    }

    logger.i("Speech Result:");
    logger.i(recordedAudioString);
  }

  // Show a snackbar message when sending a request
  void showSendingRequestMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sending request...',
          style: sidenotePoppinsFontStyle().copyWith(color: Colors.black, fontSize: 15),
        ),
        duration: const Duration(seconds: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: snackBarColorPink,
      ),
    );
  }

  // Handle text search
  void handleTextSearch(String query) {
    sendRequestToOpenAI(query);
  }

  // Send request to OpenAI
  Future<void> sendRequestToOpenAI(String userInput) async {
    stopListeningNow();

    setState(() {
      isLoading = true;
    });

    showSendingRequestMessage();

    // Send the request to AI
    await APIService().requestOpenAI(userInput, modeOfAI, 2000).then((value) {
      setState(() {
        isLoading = false;
      });

      if (value.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Your API key is not working.",
            ),
          ),
        );
      }

      userInputTextEditingController.clear();

      final responseAvailable = jsonDecode(value.body);

      if (modeOfAI == "chat") {
        // Chat mode
        setState(() {
          answerTextFromAI = responseAvailable["choices"][0]["message"]["content"];

          logger.i("AI Chat Mode: ");
          logger.i(answerTextFromAI);

          if (speakAI == true) {
            textToSpeechInstance.speak(answerTextFromAI);
          }
        });
      } else {
        // Image mode
        setState(() {
          imageUrlFromAI = responseAvailable["data"][0]["url"];

          logger.i("Generated Dale E Image Url: ");
          logger.i(imageUrlFromAI);
        });
      }
    }).catchError((errorMessage) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: ${errorMessage.toString()}",
          ),
        ),
      );
    });
  }

  // Get the public directory path
  Future<String?> getPublicDirectoryPath(String directoryName) async {
    Directory? directory = await getExternalStorageDirectory();
    String? publicDirectoryPath = directory?.path;

    if (publicDirectoryPath != null) {
      publicDirectoryPath = '$publicDirectoryPath/$directoryName';
      logger.i("public dir" + publicDirectoryPath);
      logger.i(publicDirectoryPath);

      await Directory(publicDirectoryPath).create(recursive: true);
    }

    return publicDirectoryPath;
  }

  // Initilize Flutter downloader
  void initializeFlutterDownloader() async {
    await FlutterDownloader.initialize(
      debug: true,
      ignoreSsl: true,
    );
  }

  @override
  void initState() {
    super.initState();

    initializeSpeechToText();

    initializeFlutterDownloader();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(currentUser.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!.data();
          if (userData is Map<String, dynamic>) {
            final username = userData['username'] ?? 'N/A';
            final avatarUrl = userData['avatar'] as String?;
            return Scaffold(
              appBar: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    color: backgroundColorPink,
                  ),
                ),
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: CircleAvatar(
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('images/avatar.png')
                              as ImageProvider<Object>?,
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    color: backgroundColorPink,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 13.0, top: 2.0, right: 13.0, bottom: 8.0),
                      child: Column(
                        children: [
                          // button row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ModeButtonBuilder.buildModeButton(
                                "chat",
                                "chats",
                                "images/chats_icon.png",
                                "images/white_chats_icon.png",
                                modeOfAI,
                                (mode) {
                                  setState(() {
                                    modeOfAI = mode;
                                  });
                                },
                              ),
                              ModeButtonBuilder.buildModeButton(
                                "images",
                                "images",
                                "images/images_icon.png",
                                "images/white_images_icon.png",
                                modeOfAI,
                                (mode) {
                                  setState(() {
                                    modeOfAI = mode;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24.0),

                          // Hi text
                          Text(
                            "Hi, $username !",
                            style: bricolageGrotesqueFontStyle(),
                          ),
                          const SizedBox(height: 3.0),

                          gradientText(
                            text: 'Say Something',
                            style: headingBricolageGrotesqueFontStyle(),
                          ),

                          const SizedBox(
                            height: 20.0,
                          ),

                          // Voice assistant
                          Center(
                            child: InkWell(
                              onTap: () {
                                speechToTextInstance.isListening
                                    ? stopListeningNow()
                                    : startListeningNow();
                              },
                              child: speechToTextInstance.isListening
                                  ? ListeningUI(
                                      isLoading: isLoading,
                                      showCloseButton: showCloseButton,
                                      stopListeningNow: stopListeningNow,
                                      speechToTextInstance: speechToTextInstance,)
                                  : const NotListeningUI(),
                            ),
                          ),

                          // Sound button
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0, bottom: 32.0),
                              child: SizedBox(
                                width: 50.0,
                                child: SoundButton(
                                  speakAI: speakAI,
                                  isLoading: isLoading,
                                  onPressed: () {
                                    if (!isLoading) {
                                      setState(() {
                                        speakAI = !speakAI;
                                      });
                                    }
                                    textToSpeechInstance.stop();
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Text input field
                          TextInputField(onSearch: handleTextSearch),
                          const SizedBox(height: 10.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 13.0, vertical: 10.0),
                            child: Container(
                              margin: const EdgeInsets.only(left: 0, right: 0),
                              width: 450.0,
                              // height: 400,
                              decoration: BoxDecoration(
                                color: backgroundColorPink,
                                borderRadius: BorderRadius.circular(25.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 16.0),
                              child: DisplayResult(
                                modeOfAI: modeOfAI,
                                answerTextFromAI: answerTextFromAI,
                                imageUrlFromAI: imageUrlFromAI,
                                isDownloadComplete: isDownloadComplete,
                                getPublicDirectoryPath: getPublicDirectoryPath,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('User data is not a valid Map.'),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading user data ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
