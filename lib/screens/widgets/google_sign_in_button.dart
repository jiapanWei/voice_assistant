import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/services/auth_service.dart';
import 'package:voice_assistant/screens/home_screen.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: OutlinedButton(
        style: transparentButtonStyle(),
        onPressed: () async {
          UserCredential? userCredential = await AuthService().signInWithGoogle();
          if (userCredential != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Login Failed'),
                content: const Text('Failed to sign in with Google.'),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/google.png',
              height: 24.0,
              width: 24.0,
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: poppinsFontStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
