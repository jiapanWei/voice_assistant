import "dart:convert";
import "dart:io";

import "package:flutter/material.dart";

import "package:flutter_downloader/flutter_downloader.dart";
import "package:image_gallery_saver/image_gallery_saver.dart";
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "package:voice_assistant/api/api_service.dart";
import 'package:text_to_speech/text_to_speech.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/widgets/build_display_results.dart';
import 'package:voice_assistant/screens/widgets/build_listening_ui.dart';
import 'package:voice_assistant/screens/widgets/build_mode_button.dart';
import 'package:voice_assistant/screens/widgets/build_not_listening_ui.dart';
import 'package:voice_assistant/screens/widgets/build_sound_button.dart';
import 'package:voice_assistant/screens/widgets/build_text_input_field.dart';

import 'package:voice_assistant/screens/widgets/build_drawer.dart';
import 'package:voice_assistant/screens/login_screen.dart';
import 'package:voice_assistant/screens/success_login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({
    super.key,
    required this.username,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  TextEditingController userInputTextEditingController =
      TextEditingController();

  final SpeechToText speechToTextInstance = SpeechToText();
  String recordedAudioString = "";
  bool isLoading = false;
  bool showCloseButton = false;

  String modeOfAI = "";
  String imageUrlFromAI = "";
  String answerTextFromAI = "";
  bool isDownloadComplete = false;

  bool speakAI = true;
  final TextToSpeech textToSpeechInstance = TextToSpeech();

  void initializeSpeechToText() async {
    await speechToTextInstance.initialize();

    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      isLoading = true;
      showCloseButton = true;
    });

    print('Before: ${speechToTextInstance.isListening}');

    await speechToTextInstance.listen(onResult: onSpeechToTextResult);

    print('After: ${speechToTextInstance.isListening}');
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();

    setState(() {
      isLoading = false;
      showCloseButton = false;
    });
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    print('onSpeechToTextResult called');
    print(
        'recognitionResult.recognizedWords: ${recognitionResult.recognizedWords}');
    print('recognitionResult.finalResult: ${recognitionResult.finalResult}');
    recordedAudioString = recognitionResult.recognizedWords;

    if (!speechToTextInstance.isListening) {
      sendRequestToOpenAI(recordedAudioString);
    }

    print("Speech Result:");
    print(recordedAudioString);
  }

  void showSendingRequestMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Sending request...',
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Arial",
            fontSize: 16,
          ),
        ),
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: snackBarColorPink,
      ),
    );
  }

  void handleTextSearch(String query) {
    sendRequestToOpenAI(query);
  }

  Future<void> sendRequestToOpenAI(String userInput) async {
    stopListeningNow();

    setState(() {
      isLoading = true;
    });

    showSendingRequestMessage();

    // send the request to AI
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
        setState(() {
          answerTextFromAI =
              responseAvailable["choices"][0]["message"]["content"];

          print("AI Chatbot: ");
          print(answerTextFromAI);

          if (speakAI == true) {
            textToSpeechInstance.speak(answerTextFromAI);
          }
        });
      } else {
        //image generation
        setState(() {
          imageUrlFromAI = responseAvailable["data"][0]["url"];

          print("Generated Dale E Image Url: ");
          print(imageUrlFromAI);
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

  Future<String?> getPublicDirectoryPath(String directoryName) async {
    Directory? directory = await getExternalStorageDirectory();
    String? publicDirectoryPath = directory?.path;

    if (publicDirectoryPath != null) {
      publicDirectoryPath = '$publicDirectoryPath/$directoryName';
      print("public dir" + publicDirectoryPath);
      print(publicDirectoryPath);

      await Directory(publicDirectoryPath).create(recursive: true);
    }

    return publicDirectoryPath;
  }

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
    return Scaffold(
      appBar: AppBar(
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 16.0),
        //   child: IconButton(
        //     icon: const Icon(Icons.arrow_back),
        //     // onPressed: () async {
        //     //   await FirebaseAuth.instance.signOut();
        //     //   _navigatorKey.currentState?.pushReplacementNamed('/login');
        //   ),
        // ),

        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: backgroundColorPink,
          ),
        ),

        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/avatar.png'),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(username: widget.username),
      body: Stack(
        children: [
          Container(
            color: backgroundColorPink,
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 13, top: 2, right: 13, bottom: 8),
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
                  const SizedBox(height: 24),

                  // hi text
                  Text(
                    "Hi, ${widget.username} !",
                    style: bricolageGrotesqueFontStyle(),
                  ),
                  const SizedBox(height: 3),

                  gradientText(
                    text: 'Say Something',
                    style: headingBricolageGrotesqueFontStyle(),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // voice assistant
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
                              stopListeningNow: stopListeningNow)
                          : const NotListeningUI(),
                    ),
                  ),

                  // sound button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 32.0),
                      child: SizedBox(
                        width: 50,
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

                  // text input field
                  TextInputField(onSearch: handleTextSearch),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 13, vertical: 10.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 0, right: 0),
                      width: 450,
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
  }
}
