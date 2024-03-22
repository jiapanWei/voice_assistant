import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:voice_assistant/screens/widgets/logging.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final Logger logger = getLogger();
  String newPassword = '';

  Future<bool> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (newPassword.length < 6) {
      logger.w('Password must be at least 6 characters long.');
      return false;
    }

    if (user == null) {
      logger.w('No user is signed in.');
      return false;
    }

    try {
      await user.updatePassword(newPassword);
      logger.i('Password changed successfully');
      return true;
    } catch (error) {
      logger.e('Password can\'t be changed$error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: TextField(
        onChanged: (value) {
          newPassword = value;
        },
        decoration: const InputDecoration(hintText: "Enter new password"),
        obscureText: true,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Submit'),
          onPressed: () async {
            bool passwordChanged = await changePassword(newPassword);
            Navigator.of(context).pop(passwordChanged);
          },
        ),
      ],
    );
  }
}
