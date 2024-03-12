import "dart:convert";

import "package:flutter/material.dart";

import "package:speech_to_text/speech_recognition_result.dart";
import "package:speech_to_text/speech_to_text.dart";
import 'package:lottie/lottie.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import "package:voice_assistant/api/api_service.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
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

  String modeOfAI = "";
  String imageUrlFromAI = "";
  String answerTextFromAI = "";

  void initializeSpeechToText() async {
    await speechToTextInstance.initialize();

    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      showCloseButton = true;
    });

    await speechToTextInstance.listen(onResult: onSpeechToTextResult);
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

    if (!speechToTextInstance.isListening) {
      sendRequestToOpenAI(recordedAudioString);
    }

    print("Speech Result:");
    print(recordedAudioString);
  }

  Future<void> sendRequestToOpenAI(String userInput) async {
    stopListeningNow();

    setState(() {
      isLoading = true;
    });

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

          print("ChatGPT Chatbot: ");
          print(answerTextFromAI);
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
            "Error: " + errorMessage.toString(),
          ),
        ),
      );
    });
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
          // Container(
          //   color: Color.fromRGBO(255, 239, 252, 1.0),
                    Container(
          color: Color.fromRGBO(255, 239, 252, 1.0),
        ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 13, top: 2, right: 13, bottom: 8),
                child: Column(
                  children: [
                    // button row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // chat button
                        SizedBox(
                          width: 130,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // handle Chats button click event
                              setState(() {
                                if (modeOfAI == "chat") {
                                  modeOfAI = "";
                                } else {
                                  modeOfAI = "chat";
                                }
                              });
                            },
                            icon: Image.asset(
                              "images/chats_icon.png",
                              width: 24,
                              height: 24,
                            ),
                            label: Text(
                              "chats",
                              style: TextStyle(
                                color: modeOfAI == "chat"
                                    ? Color.fromRGBO(51, 40, 40, 1)
                                    : Colors.black,
                                fontFamily: "Arial",
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: modeOfAI == "chat"
                                  ? Color.fromRGBO(232, 220, 253, 1)
                                  : null,
                            ),
                          ),
                        ),

                        // images button
                        SizedBox(
                          width: 130,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // handle images button click event
                              setState(() {
                                if (modeOfAI == "images") {
                                  modeOfAI = "";
                                } else {
                                  modeOfAI = "images";
                                }
                              });
                            },
                            icon: Image.asset(
                              "images/images_icon.png",
                              width: 24,
                              height: 24,
                            ),
                            label: Text(
                              "images",
                              style: TextStyle(
                                color: modeOfAI == "chat"
                                    ? Color.fromRGBO(51, 40, 40, 1)
                                    : Colors.black,
                                fontFamily: "Arial",
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: modeOfAI == "images"
                                  ? Color.fromRGBO(232, 220, 253, 1)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // hello text
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

                    // voice assistant
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
                                  alignment: Alignment.topRight,
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

                                      if (userInputTextEditingController
                                          .text.isNotEmpty) {
                                        sendRequestToOpenAI(
                                            userInputTextEditingController.text
                                                .toString());
                                      }

                                      // if (userInputTextEditingController
                                      //     .text.isNotEmpty) {
                                      //   setState(() {
                                      //     answerTextFromAI =
                                      //         "Hello, my name is MiMi. I am an AI assistant created by Amy and Hailey.";
                                      //   });
                                      //   if (speakFRIDAY == true) {
                                      //     print("it's friday");
                                      //     textToSpeechInstance
                                      //         .speak(answerTextFromAI);
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
                    SizedBox(height: 10),

                    // display result
                    // modeOfAI == "chat" ? SelectableText(
                    //   answerTextFromAI,
                    // ) : modeOfAI == "image" && imageUrlFromAI.isNotEmpty ? Column() : Container()

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            modeOfAI == "chat"
                                ? answerTextFromAI.isNotEmpty
                                    ? SelectableText(
                                        answerTextFromAI,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      )
                                    : Text(
                                        'Welcome to MiMi, your friendly AI voice assistant! 🎉\n'
                                        'Hi there! I\'m MiMi, an AI assistant created by Amy and Hailey. '
                                        'I\'m here to help you with all sorts of tasks and make your day a little brighter! 😊\n'
                                        'To get started, just tap on the microphone button and say something. '
                                        'I\'m always ready to listen and assist you with:\n'
                                        '- Answering questions on various topics 🌐\n'
                                        '- Helping you write emails, essays, or any other text 📝\n'
                                        '- Providing recommendations and suggestions 💡\n'
                                        '- Engaging in fun conversations and sharing jokes 😄\n'
                                        '- And so much more!\n'
                                        'Feel free to explore my capabilities and let me know how I can be of assistance.',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      )
                                : modeOfAI == "images" &&
                                        imageUrlFromAI.isNotEmpty
                                    ? Column(
                                        children: [
                                          Image.network(imageUrlFromAI),
                                          SizedBox(height: 8),
                                          Text(
                                            "Generated Image",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : modeOfAI == ""
                                        ? Text(
                                            'Welcome to MiMi, your friendly AI voice assistant! 🎉\n'
                                            'Hi there! I\'m MiMi, an AI assistant created by Amy and Hailey. '
                                            'I\'m here to help you with all sorts of tasks and make your day a little brighter! 😊\n'
                                            'To get started, just tap on the microphone button and say something. '
                                            'I\'m always ready to listen and assist you with:\n'
                                            '- Answering questions on various topics 🌐\n'
                                            '- Helping you write emails, essays, or any other text 📝\n'
                                            '- Providing recommendations and suggestions 💡\n'
                                            '- Engaging in fun conversations and sharing jokes 😄\n'
                                            '- And so much more!\n'
                                            'Feel free to explore my capabilities and let me know how I can be of assistance.',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
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
