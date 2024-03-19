import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assistant/screens/auth_screen.dart';
import 'package:voice_assistant/services/auth_service.dart';
import 'package:voice_assistant/screens/authentications/auth_sign_in_providers.dart';

class LoginScreen extends StatelessWidget {
  // Style for the transparent buttons
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

  void _navigateToAuthScreen(BuildContext context, bool isNewUser) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen(isNewUser: isNewUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 239, 252, 1.0),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('images/ball.png'),
              ),
              ShaderMask(
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
                child: const Text(
                  'Hello, welcome!',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Text(
                "Log in or create an account!",
                style: GoogleFonts.bricolageGrotesque(
                  textStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: OutlinedButton(
                  style: transparentButtonStyle(),
                  onPressed: () {
                    _navigateToAuthScreen(context, true);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign up',
                        style: buttonPoppinsFontStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: OutlinedButton(
                  style: transparentButtonStyle(),
                  onPressed: () {
                    _navigateToAuthScreen(context, false);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log in',
                        style: buttonPoppinsFontStyle(),
                      ),
                    ],
                  ),
                ),
              ),
              dividerLine(),
              googleAuthButton(),
              const SizedBox(height: 5),
              microsoftAuthButton(),
            ],
          ),
        ),
      ),
    );
  }
}
