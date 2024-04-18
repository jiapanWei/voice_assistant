import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Define ToastBox class that used for a toast notification
class ToastBox {
  // Define the properties of the class
  final String msg;
  final Toast toastLength;
  final ToastGravity gravity;
  final int timeInSecForIosWeb;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;

  // Define ToastBox constructor
  ToastBox({
    required this.msg,
    this.toastLength = Toast.LENGTH_SHORT,
    this.gravity = ToastGravity.CENTER,
    this.timeInSecForIosWeb = 1,
    this.backgroundColor = Colors.green,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
  });

  // Define showToast method
  void showToast() {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}
