import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/authentications/auth_screen.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

// Define PasswordResetScreen Widget
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

// Define PasswordResetScreen state
class _PasswordResetScreenState extends State<PasswordResetScreen> {
  // Create a variable to store the email input
  String _inputEmail = '';
  // Create a global key for the form
  final _formKey = GlobalKey<FormState>();

  // Reset password
  Future<void> passwordReset() async {
    String title = '';
    String content = '';

    // Try to send password reset email
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _inputEmail);
      title = 'Success $successEmoji';
      content = 'Password reset email sent.';
    } on FirebaseAuthException catch (e) {
      // Handle errors
      if (e.code == 'user-not-found') {
        title = 'Error';
        content = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        title = 'Error';
        content = 'The email address is not valid.';
      } else if (e.code == 'too-many-requests') {
        title = 'Error';
        content = 'Too many requests. Try again later.';
      } else {
        title = 'Error';
        content = 'An unknown error occurred.';
      }
    }

    // If there is a title and content, show a dialog
    if (title.isNotEmpty && content.isNotEmpty) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigate to the AuthScreen when the back button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(isNewUser: false),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  // Build method for widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorPink,
        title: const Text('Reset Password'),
      ),
      backgroundColor: backgroundColorPink,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Notify user to enter email address
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                'Enter your email address, and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: poppinsFontStyle(),
              ),
            ),
            const SizedBox(height: 18.0),
            // Email input field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: TextFormField(
                decoration:
                    userInputDecoration(labelText: 'Email', icon: Icons.email),
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                obscureText: false,
                validator: (value) {
                  // Validate the email input
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter a valid email address with @.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // Save the email input
                  _inputEmail = value!;
                },
              ),
            ),
            const SizedBox(height: 18.0),
            // Button to submit the form and reset password
            OutlinedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  passwordReset();
                }
              },
              style: transparentButtonStyle(),
              child: Text(
                'Reset Password',
                style: poppinsFontStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
