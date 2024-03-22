import 'package:flutter/material.dart';

Future<void> showDialogBox({
  required BuildContext context,
  required String title,
  required String content,
  List<Widget>? actions,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
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
    },
  );
}
