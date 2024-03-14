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

class HomeScreen extends StatefulWidget {
  final String inputUsername;

  HomeScreen({required this.inputUsername});

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
  bool isListeningToSpeech = false;

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

    await Future.delayed(Duration(milliseconds: 600));

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
      isListeningToSpeech = false;
    });
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    print('onSpeechToTextResult called');
    print(
        'recognitionResult.recognizedWords: ${recognitionResult.recognizedWords}');
    print('recognitionResult.finalResult: ${recognitionResult.finalResult}');
    // print('recognitionResult.isCompleted: ${recognitionResult.isCompleted}');
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
            // fontWeight: FontWeight.bold,
          ),
        ),
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Color.fromARGB(255, 254, 205, 221),
      ),
    );
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
            "Error: " + errorMessage.toString(),
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
          padding: EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ),

        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 239, 252, 1.0), // Set background color
          ),
        ),
        elevation: 0, // Remove shadow
        actions: [
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
            color: Color.fromRGBO(255, 239, 252, 1.0),
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
                      // chat button
                      SizedBox(
                        width: 130,
                        height: 48,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // handle Chats button click event
                            setState(
                              () {
                                if (modeOfAI == "chat") {
                                  modeOfAI = "";
                                } else {
                                  modeOfAI = "chat";
                                }
                              },
                            );
                          },
                          icon: modeOfAI == "chat"
                              ? Image.asset(
                                  "images/white_chats_icon.png",
                                  width: 24,
                                  height: 24,
                                )
                              : Image.asset(
                                  "images/chats_icon.png",
                                  width: 24,
                                  height: 24,
                                ),
                          label: Text("chats",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: modeOfAI == "chat"
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Colors.black,
                                  fontSize: 14,
                                ),
                              )),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: modeOfAI == "chat"
                                ? Color.fromRGBO(152, 149, 198, 1)
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
                          icon: modeOfAI == "images"
                              ? Image.asset(
                                  "images/white_images_icon.png",
                                  width: 24,
                                  height: 24,
                                )
                              : Image.asset(
                                  "images/images_icon.png",
                                  width: 24,
                                  height: 24,
                                ),
                          label: Text("images",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: modeOfAI == "images"
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              )),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: modeOfAI == "images"
                                ? Color.fromRGBO(152, 149, 198, 1)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // hello text
                  Text(
                    "Hi, ${widget.inputUsername} !",
                    style: GoogleFonts.bricolageGrotesque(
                      textStyle: const TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Say Something",
                    style: GoogleFonts.bricolageGrotesque(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
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
                          ? Center(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  isLoading
                                      ? LottieBuilder.asset(
                                          'images/ball_animation.json',
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
                      padding: const EdgeInsets.only(right: 16.0, bottom: 32.0),
                      child: SizedBox(
                        width: 40,
                        child: Container(
                          decoration: const BoxDecoration(
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
                              if (!isLoading) {
                                setState(
                                  () {
                                    speakAI = !speakAI;
                                  },
                                );
                              }
                              textToSpeechInstance.stop();
                            },
                            child: speakAI
                                ? Image.asset(
                                    "images/speaker_icon.png",
                                    width: 20, //
                                    height: 20,
                                  )
                                : Image.asset(
                                    "images/mute_icon.png",
                                    width: 20, //
                                    height: 20,
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
                            margin:
                                const EdgeInsets.only(left: 13.0, right: 13.0),
                            child: TextField(
                              controller: userInputTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Search ...",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    print("send user input");

                                    if (userInputTextEditingController
                                        .text.isNotEmpty) {
                                      sendRequestToOpenAI(
                                        userInputTextEditingController.text
                                            .toString(),
                                      );
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
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

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
                          horizontal: 16.0, vertical: 16.0),
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
                                        color:
                                            Color.fromARGB(255, 101, 100, 100),
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.middle,
                                            child: SizedBox(
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  'I\'m MiMi, your AI assistant!\n',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromRGBO(
                                                        97, 42, 116, 1.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                'Hi there! I\'m MiMi, an AI assistant created by Amy and Hailey.\n I\'m here to help you with all sorts of tasks and make your day a little brighter!  ',
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
                                                child: Image.network(
                                                    imageUrlFromAI),
                                              ),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              SizedBox(
                                                width: 230,
                                                // height: 200,
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    final imageUrl =
                                                        imageUrlFromAI;
                                                    final imageName =
                                                        'downloaded_image.jpg'; //
                                                    // final picturesDirectoryPath =
                                                    //     await getExternalStorageDirectoryPath();
                                                    final publicDirectoryPath =
                                                        await getPublicDirectoryPath(
                                                            'Pictures');

                                                    if (publicDirectoryPath !=
                                                        null) {
                                                      final taskId =
                                                          await FlutterDownloader
                                                              .enqueue(
                                                        url: imageUrl,
                                                        savedDir:
                                                            publicDirectoryPath,
                                                        showNotification: true,
                                                        openFileFromNotification:
                                                            false,
                                                        fileName: imageName,
                                                      );

                                                      final downloadTask =
                                                          await FlutterDownloader
                                                              .loadTasksWithRawQuery(
                                                                  query: "SELECT * FROM task WHERE task_id='" +
                                                                      taskId! +
                                                                      "'");
                                                      if (downloadTask !=
                                                              null &&
                                                          downloadTask
                                                              .isNotEmpty) {
                                                        final taskDetails =
                                                            downloadTask.first;
                                                        final savedDir =
                                                            taskDetails
                                                                    .savedDir ??
                                                                '';
                                                        final filename =
                                                            taskDetails
                                                                    .filename ??
                                                                '';
                                                        final filePath =
                                                            '$savedDir/$filename';

                                                        if (filePath
                                                            .isNotEmpty) {
                                                          final result =
                                                              await ImageGallerySaver
                                                                  .saveFile(
                                                                      filePath);
                                                          print(
                                                              'Image saved to gallery: $result');
                                                          setState(() {
                                                            isDownloadComplete =
                                                                true;
                                                          });
                                                        } else {
                                                          print(
                                                              'File path is empty. Cannot save image to gallery.');
                                                        }
                                                      }
                                                      if (isDownloadComplete) {
                                                        SchedulerBinding
                                                            .instance
                                                            ?.addPostFrameCallback(
                                                          (_) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                content:
                                                                    const Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            173,
                                                                            173,
                                                                            255)),
                                                                    SizedBox(
                                                                        width:
                                                                            8),
                                                                    Text(
                                                                      'Image downloaded successfully!',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontFamily:
                                                                            "Arial",
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            6),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                ),
                                                                backgroundColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        129,
                                                                        129,
                                                                        230),
                                                              ),
                                                            );
                                                            isDownloadComplete =
                                                                false;
                                                          },
                                                        );
                                                      }

                                                      // FlutterDownloader
                                                      //     .registerCallback(
                                                      //         (downloadId,
                                                      //             status,
                                                      //             progress) {
                                                      //   print(
                                                      //       'downloadId: $downloadId');
                                                      //   print(
                                                      //       'taskId: $taskId');
                                                      //   if (downloadId ==
                                                      //       taskId) {
                                                      //     print(
                                                      //         'status: $status');
                                                      //     int ds =
                                                      //         DownloadTaskStatus
                                                      //             .complete
                                                      //             .index;
                                                      //     print(
                                                      //         'DownloadTaskStatus: $ds');
                                                      //     if (status ==
                                                      //         DownloadTaskStatus
                                                      //             .complete
                                                      //             .index) {
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .showSnackBar(
                                                      //         SnackBar(
                                                      //           content:
                                                      //               const Row(
                                                      //             children: [
                                                      //               Icon(
                                                      //                   Icons
                                                      //                       .check_circle,
                                                      //                   color: Colors
                                                      //                       .green),
                                                      //               SizedBox(
                                                      //                   width:
                                                      //                       8),
                                                      //               Text(
                                                      //                 'Image downloaded successfully!',
                                                      //                 style:
                                                      //                     TextStyle(
                                                      //                   color: Colors
                                                      //                       .white,
                                                      //                   fontFamily:
                                                      //                       "Arial",
                                                      //                   fontSize:
                                                      //                       16,
                                                      //                 ),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //           duration:
                                                      //               Duration(
                                                      //                   seconds:
                                                      //                       3),
                                                      //           shape:
                                                      //               RoundedRectangleBorder(
                                                      //             borderRadius:
                                                      //                 BorderRadius
                                                      //                     .circular(
                                                      //                         8),
                                                      //           ),
                                                      //           backgroundColor:
                                                      //               Colors.green[
                                                      //                   700],
                                                      //         ),
                                                      //       );
                                                      //     } else if (status ==
                                                      //         DownloadTaskStatus
                                                      //             .failed
                                                      //             .index) {
                                                      //       ScaffoldMessenger
                                                      //               .of(context)
                                                      //           .showSnackBar(
                                                      //         SnackBar(
                                                      //           content:
                                                      //               const Row(
                                                      //             children: [
                                                      //               Icon(
                                                      //                   Icons
                                                      //                       .error,
                                                      //                   color: Colors
                                                      //                       .white),
                                                      //               SizedBox(
                                                      //                   width:
                                                      //                       8),
                                                      //               Text(
                                                      //                 'Failed to download the image.',
                                                      //                 style:
                                                      //                     TextStyle(
                                                      //                   color: Colors
                                                      //                       .white,
                                                      //                   fontFamily:
                                                      //                       "Arial",
                                                      //                   fontSize:
                                                      //                       16,
                                                      //                 ),
                                                      //               ),
                                                      //             ],
                                                      //           ),
                                                      //           duration:
                                                      //               Duration(
                                                      //                   seconds:
                                                      //                       3),
                                                      //           shape:
                                                      //               RoundedRectangleBorder(
                                                      //             borderRadius:
                                                      //                 BorderRadius
                                                      //                     .circular(
                                                      //                         8),
                                                      //           ),
                                                      //           backgroundColor:
                                                      //               Colors.red[
                                                      //                   700],
                                                      //         ),
                                                      //       );
                                                      //     }
                                                      //   }
                                                      // });
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Failed to get external storage directory.'),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            152, 149, 198, 1),
                                                  ),
                                                  child: Text(
                                                    "Download",
                                                    style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            255, 255, 255, 1),
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
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: SizedBox(
                                                  height: 30,
                                                  child: Center(
                                                    child: Text(
                                                      'I\'m MiMi, your AI assistant!\n',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromRGBO(
                                                            97, 42, 116, 1.0),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    'Hi there! I\'m MiMi, an AI assistant created by Amy and Hailey.\n I\'m here to help you with all sorts of tasks and make your day a little brighter!  ',
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
