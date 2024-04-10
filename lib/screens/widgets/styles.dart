import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const successEmoji = '\u2705';

const Color backgroundColorPink = Color.fromRGBO(255, 239, 252, 1.0);
const Color snackBarColorPink = Color.fromRGBO(242, 208, 240, 1.0);
const Color backgroundColorPurple = Color.fromARGB(255, 23, 21, 27);
const Color backgroundColorLightPurple = Color.fromARGB(255, 149, 117, 252);
const Color borderColorGrey = Color.fromARGB(255, 93, 92, 99);
const Color borderColorSoftPink = Color.fromRGBO(244, 241, 251, 0.612);

const double titleFontSize = 16;
const Color titleColor = Colors.black;

InputDecoration userInputDecoration({required String labelText, required IconData icon}) {
  return InputDecoration(
    suffixIcon: Icon(icon),
    filled: true,
    fillColor: borderColorSoftPink,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.0),
      borderSide: BorderSide.none,
    ),
    labelText: labelText,
    labelStyle: poppinsFontStyle().copyWith(fontSize: 14),
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}

ShaderMask gradientText({
  required String text,
  required TextStyle style,
}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return const LinearGradient(
        colors: [Color.fromRGBO(97, 42, 116, 1), Color.fromRGBO(232, 160, 137, 1)],
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

TextStyle typewriterGraientStyle(double fontsize) {
  return TextStyle(
    fontSize: fontsize,
    foreground: Paint()
      ..shader = const LinearGradient(
        colors: [
          Color.fromRGBO(97, 42, 116, 1),
          Color.fromRGBO(97, 42, 116, 1),
          Color.fromRGBO(244, 169, 144, 1),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.topRight,
      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
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
    color: backgroundColorPurple,
  );
}

TextStyle headingPoppinsFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
    color: borderColorGrey,
  );
}

TextStyle sidenotePoppinsFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: borderColorGrey,
  );
}

TextStyle sidenoteBricolageGrotesqueFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 13.0,
    color: borderColorGrey,
  );
}

ButtonStyle transparentButtonStyle() {
  return OutlinedButton.styleFrom(
    side: const BorderSide(width: 0.75, color: borderColorGrey),
    minimumSize: const Size(300, 37),
  );
}
