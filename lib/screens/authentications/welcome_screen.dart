import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/build_divider_line.dart';
import 'package:voice_assistant/screens/widgets/google_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/microsoft_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/authentications/auth_screen.dart';

// Define WelcomeScreen Widget
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Navigate to the AuthScreen
  void _navigateToAuthScreen(BuildContext context, bool isNewUser) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen(isNewUser: isNewUser)),
    );
  }

  // Build method for widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorPink,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add image at the top of the screen
              Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('images/ball.png'),
              ),
              // Add a welcome text
              gradientText(
                text: 'Hello, welcome!',
                style: const TextStyle(fontSize: 24),
              ),
              // Add a text to let the user know they can sign in or sign up
              Text(
                "Sign In or Create Account!",
                style: sidenoteBricolageGrotesqueFontStyle(),
              ),
              const SizedBox(height: 15),
              // Add a button to navigate to the AuthScreen for signing up
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: OutlinedButton(
                  style: transparentButtonStyle(),
                  onPressed: () {
                    _navigateToAuthScreen(context, true);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create Account',
                        style: poppinsFontStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Add a button to navigate to the AuthScreen for signing in
              Container(
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: OutlinedButton(
                  style: transparentButtonStyle(),
                  onPressed: () {
                    _navigateToAuthScreen(context, false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign In',
                        style: poppinsFontStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              // Add Google and Microsoft sign-in authentication buttons
              const DividerLine(),
              const GoogleAuthButton(),
              const SizedBox(height: 5),
              const MicrosoftAuthButton(),
            ],
          ),
        ),
      ),
    );
  }
}
