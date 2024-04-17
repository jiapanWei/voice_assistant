import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";
import 'package:voice_assistant/screens/widgets/styles.dart';

class DrawerBtn extends StatelessWidget {
  const DrawerBtn({
    super.key,
    required this.press,
    required this.isDrawerOpen,
  });

  final VoidCallback press;
  final bool isDrawerOpen;

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
