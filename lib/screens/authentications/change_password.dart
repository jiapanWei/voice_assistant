import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String newPassword = '';

  Future<void> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in.');
      return;
    }
    await user.updatePassword(newPassword).then((_) {
      print('Password changed successfully');
    }).catchError((error) {
      print('Password can\'t be changed' + error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: TextField(
        onChanged: (value) {
          newPassword = value; // Update the new password
        },
        decoration: const InputDecoration(hintText: "Enter new password"),
        obscureText: true, // Use secure text for passwords.
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            changePassword(newPassword);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
