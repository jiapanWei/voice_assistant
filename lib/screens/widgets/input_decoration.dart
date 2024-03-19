import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    labelStyle: GoogleFonts.poppins(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: const Color.fromRGBO(119, 111, 105, 1.0),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}
