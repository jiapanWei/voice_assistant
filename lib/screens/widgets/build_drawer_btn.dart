import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";
import 'package:voice_assistant/screens/widgets/styles.dart';

// Define DrawerBtn widget that used for the drawer button
class DrawerBtn extends StatelessWidget {
  // Define DrawerBtn constructor
  const DrawerBtn({
    super.key,
    required this.press,
    required this.isDrawerOpen,
  });

  // Define the variables
  final VoidCallback press;
  final bool isDrawerOpen;

  // Build the DrawerBtn widget
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: press,
        child: Container(
          margin: const EdgeInsets.only(left: 16),
          height: 35,
          width: 35,
          decoration: const BoxDecoration(
            color: backgroundColorPink,
            shape: BoxShape.circle,
          ),
          child: isDrawerOpen
              ? const Icon(CupertinoIcons.clear_thick)
              : const Icon(
                  CupertinoIcons.list_dash,
                  color: Colors.black,
                ),
        ),
      ),
    );
  }
}
