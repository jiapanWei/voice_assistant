import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assistant/screens/authentication.dart';
import 'package:voice_assistant/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final _buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  );

  void _navigateToAuthScreen(BuildContext context, bool isNewUser) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen(isNewUser: isNewUser)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 205, 221),
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
              Text(
                "Hello, welcome !",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(232, 160, 137, 251),
                ),
              ),
              Text(
                "Log in or create an account!",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color.fromARGB(232, 160, 137, 251),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToAuthScreen(context, true);
                  },
                  style: _buttonStyle,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign up',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToAuthScreen(context, false);
                  },
                  style: _buttonStyle,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Log in',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 18),
                child: const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Text(" OR "),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: ElevatedButton(
                  onPressed: () => AuthService().signInWithGoogle(),
                  style: _buttonStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/google.png', height: 24, width: 24),
                      const SizedBox(width: 10),
                      const Text('Continue with Google'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToAuthScreen(
                        context, false); //TODO: create handlers
                  },
                  style: _buttonStyle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/microsoft.png',
                          height: 24, width: 24),
                      const SizedBox(width: 10),
                      const Text('Continue with Microsoft'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
