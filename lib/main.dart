import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:voice_assistant/screens/on_boarding_screen.dart';
import 'package:voice_assistant/screens/widgets/entry_point.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/splash_screen.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate Firebase appcheck
  await FirebaseAppCheck.instance.activate(
      // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      );

  // Initialize Flutter Downloader
  await FlutterDownloader.initialize(
    debug: true,
  );

  // Sign out any existing user
  await FirebaseAuth.instance.signOut();

  // Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Virtual Assistant Application',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data != null) {
                      return const EntryPoint();
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
          '/splashScreen': (context) => const SplashScreen(),
          '/onBoardingScreen': (context) => const OnBoardingSceen(),
          '/welcomeScreen': (context) => const WelcomeScreen(),
        });
  }
}
