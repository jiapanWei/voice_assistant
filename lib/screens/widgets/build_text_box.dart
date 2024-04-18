import 'package:flutter/material.dart';
import 'package:voice_assistant/screens/widgets/styles.dart';

// Define ProfileTextBoxStyle widget
class ProfileTextBoxStyle extends StatelessWidget {
  // Define the variables
  final String text;
  final String section;
  final void Function()? onPressed;

  // Define ProfileTextBoxStyle constructor
  const ProfileTextBoxStyle(
      {super.key, required this.text, required this.section, required this.onPressed});

  // Build the ProfileTextBoxStyle widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, bottom: 6),
          alignment: Alignment.centerLeft,
          child: Text(
            section,
            style: poppinsFontStyle().copyWith(fontSize: 15.0),
          ),
        ),
        Container(
          height: 65,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: borderColorSoftPink,
          ),
          padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 0),
          margin: const EdgeInsets.only(left: 3.0, right: 30.0, top: 1.0, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: poppinsFontStyle().copyWith(fontSize: 15),
                  ),
                  // Check if onPressed is not null
                  if (onPressed != null)
                    IconButton(
                      onPressed: onPressed,
                      icon: const Icon(
                        Icons.edit,
                        color: borderColorGrey,
                      ),
                    )
                  else
                    const SizedBox(
                      width: 40.0,
                      height: 40.0,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
