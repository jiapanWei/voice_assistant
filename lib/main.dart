import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:voice_assistant/screens/on_boarding_screen.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/splash_screen.dart';

import 'package:voice_assistant/screens/authentications/welcome_screen.dart';

import 'package:voice_assistant/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(
    debug: true,
  );
  await FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Virtual Assistant Application', debugShowCheckedModeBanner: false, initialRoute: '/', routes: {
      '/': (context) => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data != null) {
                  return const HomeScreen();
                }
                return const SplashScreen();
              } else {
                return const Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('Loading...'),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
      '/splashScreen': (context) => SplashScreen(),
      '/onBoardingScreen':(context) => OnBoardingSceen(),
      '/welcomeScreen': (context) => WelcomeScreen(),
    }
        // '/register': (context) => RegistrationScreen(),
        // '/chat': (context) => ChatScreen(),
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (ctx, AsyncSnapshot<User?> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       if (snapshot.data != null) {
        //         return const HomeScreen();
        //       }
        //       // return LoginScreen();
        //       return const SplashScreen();
        //     } else {
        //       return const Scaffold(
        //         // Add a loading spinner
        //         body: Center(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               CircularProgressIndicator(),
        //               Text('Loading...'),
        //             ],
        //           ),
        //         ),
        //       );
        //     }
        //   },
        // ),
        );
  }
}
