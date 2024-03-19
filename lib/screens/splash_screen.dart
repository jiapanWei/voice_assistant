import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorPink,
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
              gradientText(
                text: 'Hello, welcome!',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SlideAction(
                  // elevation: 0,
                  innerColor: Colors.white,
                  outerColor: const Color.fromARGB(255, 254, 205, 221),
                  sliderButtonIcon: const Icon(
                    Icons.chevron_right,
                    color: Colors.pink,
                  ),
                  text: 'Get Started!',
                  textStyle: headingPoppinsFontStyle(),
                  onSubmit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
