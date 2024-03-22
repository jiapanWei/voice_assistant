import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:voice_assistant/screens/widgets/on_boarding_pages.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';
import 'package:voice_assistant/constants/colors.dart';
import 'package:voice_assistant/constants/image_strings.dart';
import 'package:voice_assistant/constants/text.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

class OnBoardingSceen extends StatefulWidget {
  const OnBoardingSceen({super.key});

  @override
  _OnBoardingSceenState createState() => _OnBoardingSceenState();
}

@override
class _OnBoardingSceenState extends State<OnBoardingSceen> {
  final controller = LiquidController();

  int currentPage = 0;

  void onPageChangeCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pages = [
      OnBoardingPages(color: onBoardingPage1Color, imagePath: onBoardingImage1, title: onBoardingTitle1, subtitle: onBoardingSubTitle1, pageNumber: onBoardingPageNum1),
      OnBoardingPages(color: onBoardingPage2Color, imagePath: onBoardingImage2, title: onBoardingTitle2, subtitle: onBoardingSubTitle2, pageNumber: onBoardingPageNum2),
      OnBoardingPages(color: onBoardingPage3Color, imagePath: onBoardingImage3, title: onBoardingTitle3, subtitle: onBoardingSubTitle3, pageNumber: onBoardingPageNum3),
    ];

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
           LiquidSwipe(
              pages: pages,
              slideIconWidget: Icon(Icons.arrow_back_ios),
              enableSideReveal: true,
              liquidController: controller,
              onPageChangeCallback: onPageChangeCallback,
            ),
          
          Positioned(
            bottom: 60,
            child: OutlinedButton(
                onPressed: () {
                  int nextPage = controller.currentPage + 1;
                  controller.animateToPage(page: nextPage);
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  // decoration: const BoxDecoration(
                  //   color: Colors.white,
                  //   shape: BoxShape.circle,
                  // ),
                  
                  child: Icon(Icons.arrow_forward_ios,
                    color: Colors.black,
                  ),
                )),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/welcomeScreen');
              },
              child: Text(
                "skip",
                style: titleStyle().copyWith(color:const Color.fromARGB(255, 44, 45, 44)),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: AnimatedSmoothIndicator(
              count: 3,
              activeIndex: controller.currentPage,
              effect: const WormEffect(
                activeDotColor: Color(0xff272727),
                dotHeight: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
