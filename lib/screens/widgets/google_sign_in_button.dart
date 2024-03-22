import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/services/auth_service.dart';

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
          Text('Continue with Google', style: poppinsFontStyle()),
        ],
      ),
    ),
  );
}
