import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';
import 'package:voice_assistant/screens/authentications/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "splash_screen";
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController sizeController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    sizeController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 200,
    );
    sizeController.forward();
    sizeController.addListener(() {
      setState(() {});
    });
    startAnimation();
  }

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 7000));
    Navigator.pushNamed(context, '/onBoardingScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorPink,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 0,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: sizeController.value,
                  child: Image.asset('images/ball.png'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 250.0,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Hello, welcome!',
                        textStyle: typewriterGraientStyle(26),
                        textAlign: TextAlign.center,
                      ),
                      TypewriterAnimatedText(
                        'This is MiMi.',
                        textStyle: typewriterGraientStyle(26),
                        textAlign: TextAlign.center,
                      ),
                      TypewriterAnimatedText(
                        'Your AI assistant.',
                        textStyle: typewriterGraientStyle(26),
                        textAlign: TextAlign.center,
                      ),
                      TypewriterAnimatedText(
                        'Happy to help you!',
                        textStyle: typewriterGraientStyle(26),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),
              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: SlideAction(
              //     elevation: 0,
              //     innerColor: Colors.white,
              //     outerColor: const Color.fromARGB(255, 254, 205, 221),
              //     sliderButtonIcon: const Icon(
              //       Icons.chevron_right,
              //       color: Colors.pink,
              //     ),
              //     text: 'Get Started',
              //     textStyle: poppinsFontStyle().copyWith(fontSize: 20.0),
              //     onSubmit: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const LoginScreen(),
              //         ),
              //       );
              //       return null;
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
