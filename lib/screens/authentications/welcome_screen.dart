import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/build_divider_line.dart';
import 'package:voice_assistant/screens/widgets/google_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/microsoft_sign_in_button.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

import 'package:voice_assistant/screens/authentications/auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToAuthScreen(BuildContext context, bool isNewUser) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen(isNewUser: isNewUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              gradientText(
                text: 'Hello, welcome!',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                "Log in or create an account!",
                style: sidenoteBricolageGrotesqueFontStyle(),
              ),
              const SizedBox(height: 15),
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
                        'Sign up',
                        style: poppinsFontStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
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
                        'Log in',
                        style: poppinsFontStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              dividerLine(),
              googleAuthButton(context),
              const SizedBox(height: 5),
              microsoftAuthButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
