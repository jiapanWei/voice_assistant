import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

class TextBoxStyle extends StatelessWidget {
  final String text;
  final String section;
  final void Function()? onPressed;

  const TextBoxStyle(
      {super.key,
      required this.text,
      required this.section,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
      margin: const EdgeInsets.only(left: 10.0, right: 40.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section,
                style: titleStyle(),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),
          Text(text)
        ],
      ),
    );
  }
}
