import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_assistant/screens/login_screen.dart';

const Color backgroundColorPink = Color.fromRGBO(255, 239, 252, 1.0);
const headingPoppinsFontStyle = TextStyle(
    fontSize: 20.0, fontWeight: FontWeight.w400, color: Color(0xFF776F69));

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
                  textStyle: headingPoppinsFontStyle,
                  onSubmit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
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
