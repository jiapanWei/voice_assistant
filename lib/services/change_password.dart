import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'package:voice_assistant/screens/widgets/build_logger_style.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

// Define ChangePassword Widget
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

// Define ChangePassword state
class _ChangePasswordState extends State<ChangePassword> {
  // Create a logger to log messages
  final Logger logger = LoggerStyle.getLogger();

  // Create a variable to store the new password
  String newPassword = '';

  // Change password
  Future<bool> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the password is at least 6 characters long
    if (newPassword.trim().length < 6) {
      logger.i('Password must be at least 6 characters long.');
      return false;
    }

    // Check if the user is signed in
    if (user == null) {
      logger.w('No user is signed in.');
      return false;
    }

    // Try to update the password
    try {
      await user.updatePassword(newPassword);
      logger.i('Password changed successfully');
      return true;
    } catch (error) {
      // Log error if password change fails
      logger.e('Password can\'t be changed$error');
      return false;
    }
  }

  // Build method for widget
  @override
  Widget build(BuildContext context) {
    // Return AlertDialog widget
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
      // Add two actions: 'Cancel' and 'Submit' to the AlertDialog
      actions: <Widget>[
        // Cancel button to close the AlertDialog without changing the password
        TextButton(
          child: Text('Cancel',
              style: sidenotePoppinsFontStyle()
                  .copyWith(color: Colors.deepPurple)),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        // Submit button to change the password
        TextButton(
          child: Text('Submit',
              style: sidenotePoppinsFontStyle()
                  .copyWith(color: Colors.deepPurple)),
          onPressed: () async {
            // Call the changePassword method to change the password
            bool passwordChanged = await changePassword(newPassword);
            // Close the AlertDialog and return the result
            Navigator.of(context).pop(passwordChanged);
          },
        ),
      ],
    );
  }
}
