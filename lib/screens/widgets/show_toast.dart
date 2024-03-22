import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToastBox({
  required String msg,
  Toast toastLength = Toast.LENGTH_SHORT,
  ToastGravity gravity = ToastGravity.CENTER,
  int timeInSecForIosWeb = 1,
  Color backgroundColor = Colors.green,
  Color textColor = Colors.white,
  double fontSize = 16.0,
}) {
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
