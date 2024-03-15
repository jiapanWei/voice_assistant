import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModeButtonBuilder {
  static Widget buildModeButton(
    String mode,
    String label,
    String iconAsset,
    String selectedIconAsset,
    String modeOfAI,
    Function(String) onModeChanged,
  ) {
    bool isSelected = modeOfAI == mode;

    return SizedBox(
      width: 170,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          onModeChanged(isSelected ? "" : mode);
        },
        icon: Image.asset(
          isSelected ? selectedIconAsset : iconAsset,
          width: 24,
          height: 24,
        ),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: isSelected ? const Color.fromRGBO(255, 255, 255, 1) : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color.fromRGBO(152, 149, 198, 1): null,
        )
      ),
    );
  }
}
