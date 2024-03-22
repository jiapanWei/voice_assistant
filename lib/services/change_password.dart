import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String newPassword = '';

  Future<bool> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in.');
      return false;
    }
    try {
      await user.updatePassword(newPassword);
      print('Password changed successfully');
      return true;
    } catch (error) {
      print('Password can\'t be changed' + error.toString());
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
