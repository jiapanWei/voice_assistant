import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:voice_assistant/screens/on_boarding_screen.dart';
import 'package:voice_assistant/screens/widgets/entry_point.dart';
import 'package:voice_assistant/screens/splash_screen.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';

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

  // Build the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Virtual Assistant Application',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // Define the routes for the application
          '/': (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    // If the user is logged in, navigate to the EntryPoint screen
                    if (snapshot.data != null) {
                      return const EntryPoint();
                    }
                    // If the user is not logged in, navigate to the SplashScreen
                    return const SplashScreen();
                  } else {
                    // If the connection state is not active, show a loading screen
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
