import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color backgroundColorPink = Color.fromRGBO(255, 239, 252, 1.0);
const Color snackBarColorPink = Color.fromARGB(255, 254, 205, 221);

const double titleFontSize = 16;
const Color titleColor = Colors.black;

ShaderMask gradientText({
  required String text,
  required TextStyle style,
}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return const LinearGradient(
        colors: [
          Color.fromRGBO(97, 42, 116, 1),
          Color.fromRGBO(232, 160, 137, 1)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds);
    },
    blendMode: BlendMode.srcIn,
    child: Text(
      text,
      style: style,
    ),
  );
}

// Font Style: GoogleFonts.bricolageGrotesque
TextStyle titleStyle() {
  return GoogleFonts.bricolageGrotesque(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: titleColor,
  );
}

TextStyle bricolageGrotesqueFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: titleColor,
  );
}

TextStyle headingBricolageGrotesqueFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 23.0,
    fontWeight: FontWeight.w500,
    color: titleColor,
  );
}

// Font Style: GoogleFonts.poppins
TextStyle poppinsFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: const Color.fromRGBO(119, 111, 105, 1.0),
  );
}

TextStyle headingPoppinsFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: const Color.fromRGBO(119, 111, 105, 1.0),
  );
}

TextStyle sidenotePoppinsFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: const Color.fromRGBO(119, 111, 105, 1.0),
  );
}

TextStyle sidenoteBricolageGrotesqueFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 13.0,
    color: Colors.grey,
  );
}

ButtonStyle transparentButtonStyle() {
  return OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.grey),
    minimumSize: const Size(300, 37),
  );
}
