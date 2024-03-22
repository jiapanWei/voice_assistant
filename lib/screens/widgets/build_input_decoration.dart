import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

InputDecoration userInputDecoration(
    {required String labelText, required IconData icon}) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(105.0),
      borderSide: BorderSide.none,
    ),
    labelText: labelText,
    labelStyle: poppinsFontStyle(),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}
