import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/services/auth_service.dart';

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
          Text('Continue with Microsoft', style: poppinsFontStyle()),
        ],
      ),
    ),
  );
}
