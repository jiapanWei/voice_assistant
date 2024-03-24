import 'package:flutter/material.dart';

class AlertDialogBox extends Dialog {
  final String title;
  final String content;
  final List<Widget>? actions;

  const AlertDialogBox({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

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
                Navigator.of(context).pop();
              },
            ),
          ],
    );
  }
}
