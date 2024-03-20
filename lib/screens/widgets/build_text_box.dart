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
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
      margin: const EdgeInsets.only(left: 8.0, right: 30.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                section,
                style: poppinsFontStyle().copyWith(fontSize: 14.0),
              ),
              if (onPressed != null)
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Colors.grey[400],
                  ),
                )
              else
                const SizedBox(
                  width: 48.0,
                  height: 48.0,
                ),
            ],
          ),
          Text(text)
        ],
      ),
    );
  }
}
