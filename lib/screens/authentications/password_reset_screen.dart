import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assistant/screens/widgets/input_decoration.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  String _inputEmail = '';
  final _formKey = GlobalKey<FormState>();

  ButtonStyle transparentButtonStyle = OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.grey),
    minimumSize: const Size(300, 37),
  );

  TextStyle poppinsFontStyle = GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: const Color.fromRGBO(119, 111, 105, 1.0),
  );

  Future<void> passwordReset() async {
    String title = '';
    String content = '';

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _inputEmail);
      title = 'Success';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
        title: const Text('Reset Password'),
      ),
      backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
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
                style: poppinsFontStyle,
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
              style: transparentButtonStyle,
              child: Text(
                'Reset Password',
                style: poppinsFontStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
