import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'package:voice_assistant/screens/widgets/build_logger_style.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final Logger logger = LoggerStyle.getLogger();
  String newPassword = '';

  Future<bool> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (newPassword.trim().length < 6) {
      logger.i('Password must be at least 6 characters long.');
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
      title: Text(
        'Change Password',
        style: headingPoppinsFontStyle().copyWith(color: Colors.black),
      ),
      content: TextField(
        onChanged: (value) {
          newPassword = value;
        },
        decoration: InputDecoration(
          hintText: "Enter new password",
          hintStyle: sidenotePoppinsFontStyle().copyWith(fontSize: 15),
        ),
        obscureText: true,
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: sidenotePoppinsFontStyle().copyWith(color: Colors.deepPurple)),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text('Submit', style: sidenotePoppinsFontStyle().copyWith(color: Colors.deepPurple)),
          onPressed: () async {
            bool passwordChanged = await changePassword(newPassword);
            Navigator.of(context).pop(passwordChanged);
          },
        ),
      ],
    );
  }
}
