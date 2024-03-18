import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:voice_assistant/services/auth_service.dart';

ButtonStyle transparentButtonStyle() {
  return OutlinedButton.styleFrom(
    side: const BorderSide(color: Colors.grey),
    minimumSize: const Size(300, 37),
  );
}

TextStyle buttonPoppinsFontStyle() {
  return GoogleFonts.poppins(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: const Color.fromRGBO(119, 111, 105, 1.0),
  );
}

Container dividerLine() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 18),
    child: const Row(
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Text(
          " OR ",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    ),
  );
}

Container googleAuthButton() {
  return Container(
    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
    child: OutlinedButton(
      style: transparentButtonStyle(),
      onPressed: () => AuthService().signInWithGoogle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/google.png', height: 24.0, width: 24.0),
          const SizedBox(width: 10),
          Text('Continue with Google', style: buttonPoppinsFontStyle()),
        ],
      ),
    ),
  );
}

Container microsoftAuthButton() {
  return Container(
    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
    child: OutlinedButton(
      style: transparentButtonStyle(),
      onPressed: () => AuthService().signInWithMicrosoft(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/microsoft.png', height: 24.0, width: 24.0),
          const SizedBox(width: 10),
          Text('Continue with Microsoft', style: buttonPoppinsFontStyle()),
        ],
      ),
    ),
  );
}
