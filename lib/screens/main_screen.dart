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
import 'package:voice_assistant/screens/authentication.dart';
import 'package:voice_assistant/screens/widgets/build_listening_ui.dart';
import 'package:voice_assistant/screens/widgets/build_mode_button.dart';
import 'package:voice_assistant/screens/widgets/build_not_listening_ui.dart';
import 'package:voice_assistant/screens/widgets/build_sound_button.dart';
import 'package:voice_assistant/screens/widgets/build_text_input_field.dart';

const double titleFontSize = 25;
const Color titleColor = Colors.black;

const Color backgroundColorPink = Color.fromRGBO(255, 239, 252, 1.0);
const Color snackBarColorPink = Color.fromARGB(255, 254, 205, 221);

TextStyle titleStyle = GoogleFonts.bricolageGrotesque(
  textStyle: const TextStyle(
    fontSize: titleFontSize,
    color: titleColor,
  ),
);

class HomeScreen extends StatefulWidget {
  final String inputUsername;

  const HomeScreen({
    super.key,
    required this.inputUsername,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userInputTextEditingController = TextEditingController();

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
    print('recognitionResult.recognizedWords: ${recognitionResult.recognizedWords}');
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
          answerTextFromAI = responseAvailable["choices"][0]["message"]["content"];

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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
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
      body: Stack(
        children: [
          Container(
            color: backgroundColorPink,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 13, top: 2, right: 13, bottom: 8),
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
                    "Hi, ${widget.inputUsername} !",
                    style: titleStyle,
                  ),
                  const SizedBox(height: 5),
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Color.fromRGBO(97, 42, 116, 1), Color.fromRGBO(232, 160, 137, 1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.srcIn,
                    child: const Text(
                      'say somthing',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),

                  // voice assistant
                  Center(
                    child: InkWell(
                      onTap: () {
                        speechToTextInstance.isListening ? stopListeningNow() : startListeningNow();
                      },
                      child: speechToTextInstance.isListening ? ListeningUI(isLoading: isLoading, showCloseButton: showCloseButton, stopListeningNow: stopListeningNow) : const NotListeningUI(),
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

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 239, 252, 1.0),
                        borderRadius: BorderRadius.circular(25.0),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          modeOfAI == "chat"
                              ? answerTextFromAI.isNotEmpty
                                  ? SelectableText(
                                      answerTextFromAI,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                        color: Color.fromARGB(255, 101, 100, 100),
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment: PlaceholderAlignment.middle,
                                            child: SizedBox(
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  'I\'m MiMi, your AI assistant!\n',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(97, 42, 116, 1.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Hi there! I\'m MiMi, an AI assistant created by Amy and Hailey.\n I\'m here to help you with all sorts of tasks and make your day a little brighter!  ',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
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
                                              SizedBox(
                                                width: 225,
                                                child: Image.network(imageUrlFromAI),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              SizedBox(
                                                width: 230,
                                                // height: 200,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final imageUrl = imageUrlFromAI;
                                                    final imageName = 'downloaded_image.jpg'; //
                                                    // final picturesDirectoryPath =
                                                    //     await getExternalStorageDirectoryPath();
                                                    final publicDirectoryPath = await getPublicDirectoryPath('Pictures');

                                                    if (publicDirectoryPath != null) {
                                                      final taskId = await FlutterDownloader.enqueue(
                                                        url: imageUrl,
                                                        savedDir: publicDirectoryPath,
                                                        showNotification: true,
                                                        openFileFromNotification: false,
                                                        fileName: imageName,
                                                      );

                                                      final downloadTask = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE task_id='" + taskId! + "'");
                                                      if (downloadTask != null && downloadTask.isNotEmpty) {
                                                        final taskDetails = downloadTask.first;
                                                        final savedDir = taskDetails.savedDir ?? '';
                                                        final filename = taskDetails.filename ?? '';
                                                        final filePath = '$savedDir/$filename';

                                                        if (filePath.isNotEmpty) {
                                                          final result = await ImageGallerySaver.saveFile(filePath);
                                                          print('Image saved to gallery: $result');
                                                          setState(() {
                                                            isDownloadComplete = true;
                                                          });
                                                        } else {
                                                          print('File path is empty. Cannot save image to gallery.');
                                                        }
                                                      }
                                                      if (isDownloadComplete) {
                                                        SchedulerBinding.instance?.addPostFrameCallback(
                                                          (_) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: const Row(
                                                                  children: [
                                                                    Icon(Icons.check_circle, color: Color.fromARGB(255, 173, 173, 255)),
                                                                    SizedBox(width: 8),
                                                                    Text(
                                                                      'Image downloaded successfully!',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontFamily: "Arial",
                                                                        fontSize: 16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                duration: Duration(seconds: 6),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                backgroundColor: Color.fromARGB(255, 129, 129, 230),
                                                              ),
                                                            );
                                                            isDownloadComplete = false;
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                          content: Text('Failed to get external storage directory.'),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(152, 149, 198, 1),
                                                  ),
                                                  child: Text(
                                                    "Download",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(255, 255, 255, 1),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          width: 230,
                                          child: LottieBuilder.asset(
                                            'images/image_animation.json',
                                            width: 150,
                                            height: 150,
                                          ),
                                        )
                                  : modeOfAI == ""
                                      ? RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                alignment: PlaceholderAlignment.middle,
                                                child: SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text(
                                                      'I\'m MiMi, your AI assistant!\n',
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w400,
                                                        color: Color.fromRGBO(97, 42, 116, 1.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: 'Hi there! I\'m MiMi, an AI assistant created by Amy and Hailey.\n I\'m here to help you with all sorts of tasks and make your day a little brighter!  ',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(),
                        ],
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
