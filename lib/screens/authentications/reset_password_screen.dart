import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/widgets/build_input_decoration.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  String _inputEmail = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> passwordReset() async {
    String title = '';
    String content = '';

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _inputEmail);
      title = 'Success $successEmoji';
      content = 'Password reset email sent.';
    } on FirebaseAuthException catch (e) {
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Text(
                'Enter your email address, and we will send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: poppinsFontStyle(),
              ),
            ),
            const SizedBox(height: 18.0),
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
                  if (value == null ||
                      value.trim().isEmpty ||
                      !value.contains('@')) {
                    return 'Please enter a valid email address with @.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _inputEmail = value!;
                },
              ),
            ),
            const SizedBox(height: 18.0),
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
