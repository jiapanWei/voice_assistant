import 'package:flutter/material.dart';

// Define AlertDialogBox widget that used for the alert dialog box
class AlertDialogBox extends Dialog {
  final String title;
  final String content;
  final List<Widget>? actions;

  // Define AlertDialogBox constructor
  const AlertDialogBox({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  // Build the AlertDialogBox widget
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions ??
          [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Close the dialog box after pressing 'OK'
                Navigator.of(context).pop();
              },
            ),
          ],
    );
  }
}
