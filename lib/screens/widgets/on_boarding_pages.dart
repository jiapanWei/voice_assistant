import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

class OnBoardingPages extends StatelessWidget {
  final Color color;
  final String imagePath;
  final String title;
  final String subtitle;
  final String pageNumber;

  const OnBoardingPages({
    super.key,
    required this.color,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(30),
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(imagePath, height: size.height * 0.4),
          Column(
            children: [
              Text(title, textAlign: TextAlign.center, style: bricolageGrotesqueFontStyle()),
              Text(subtitle, textAlign: TextAlign.center, style: titleStyle()),
            ],
          ),
          Text(pageNumber, style: titleStyle()),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
