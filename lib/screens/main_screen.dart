import "package:flutter/material.dart";

import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController userInputTextEditingController =
      TextEditingController();

  final SpeechToText speechToTextInstance = SpeechToText();
  String recordedAudioString = "";
  bool isLoading = false;
  bool showCloseButton = false;

  void initializeSpeechToText() async {
    await speechToTextInstance.initialize();

    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();

    await speechToTextInstance.listen(onResult: onSpeechToTextResult);

    setState(() {
      isLoading = true;
      showCloseButton = true;
    });
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();

    setState(() {
      isLoading = false;
      showCloseButton = false;
    });
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    recordedAudioString = recognitionResult.recognizedWords;

    print("Speech Result:");
    print(recordedAudioString);
  }

  @override
  void initState() {
    super.initState();

    initializeSpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 239, 252, 1.0),
          ),
        ),
        title: Image.asset(
          "images/arrow.png",
          width: 24,
        ),
        titleSpacing: 8,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromRGBO(255, 239, 252, 1.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 13, top: 2, right: 13, bottom: 8),
                child: Column(
                  children: [
                    // button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // 处理 Chats 按钮点击事件
                            },
                            icon: Image.asset(
                              "images/chats_icon.png",
                              width: 24,
                              height: 24,
                            ),
                            label: Text("Chats"),
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // 处理 Images 按钮点击事件
                            },
                            icon: Image.asset(
                              "images/images_icon.png",
                              width: 24,
                              height: 24,
                            ),
                            label: Text("Images"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    //text
                    Text(
                      "Hi, Alex",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Say Something",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),

                    Center(
                      child: InkWell(
                        onTap: () {
                          print('Before: ${speechToTextInstance.isListening}');
                          speechToTextInstance.isListening
                              ? stopListeningNow()
                              : startListeningNow();
                          print('After: ${speechToTextInstance.isListening}');
                        },
                        child: speechToTextInstance.isListening
                            ? Center(
                                child: Stack(
                                  alignment: Alignment.topRight, // 将关闭按钮放置在右上角
                                  children: [
                                    isLoading
                                        ? LottieBuilder.asset(
                                            'images/voice_animation.json',
                                            width: 200,
                                            height: 200,
                                          )
                                        : Image.asset(
                                            "images/ball.png",
                                            height: 120,
                                            width: 120,
                                          ),
                                    if (showCloseButton)
                                      Positioned(
                                        top: 10,
                                        right: 10,
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Transform.scale(
                                            scale: 0.75,
                                            child: CloseButton(
                                              color: Colors.grey,
                                              onPressed: stopListeningNow,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : Image.asset(
                                "images/ball.png",
                                height: 120,
                                width: 120,
                              ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // sound icon
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 16.0, bottom: 32.0),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color.fromARGB(255, 242, 201, 249),
                                Color.fromARGB(255, 255, 238, 252),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: FloatingActionButton(
                            onPressed: () {
                              // 点击事件处理
                            },
                            child: Image.asset(
                              "images/speaker_icon.png",
                              width: 32, //
                              height: 32,
                            ),
                            shape: CircleBorder(),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            highlightElevation: 0,
                          ),
                        ),
                      ),
                    ),

                    // text input field
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 13.0, right: 13.0),
                            decoration: BoxDecoration(
                                // color: Colors.white,

                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                )
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 2,
                                //     blurRadius: 5,
                                //     offset: Offset(0, 3),
                                //   ),
                                // ],
                                ),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 13.0, right: 13.0),
                              child: TextField(
                                controller: userInputTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Search ...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      print("send user input");
                                      // if (userInputTextEditingController
                                      //     .text.isNotEmpty) {
                                      //   setState(() {
                                      //     answerTextFromOpenAI =
                                      //         "Hello, my name is MiMi. I am an AI assistant created by Amy and Hailey.";
                                      //   });
                                      //   if (speakFRIDAY == true) {
                                      //     print("it's friday");
                                      //     textToSpeechInstance
                                      //         .speak(answerTextFromOpenAI);
                                      //   }
                                      // } else {
                                      //   sendRequestToOpenAI(
                                      //       userInputTextEditingController.text
                                      //           .toString());
                                      // }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Image.asset(
                                        "images/search_icon.png",
                                        width: 24,
                                        height: 24,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 13, vertical: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 239, 252, 1.0),
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'How can I forget a bad memory?',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
