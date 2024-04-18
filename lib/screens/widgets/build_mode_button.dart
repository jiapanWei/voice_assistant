import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define ModeButtonBuilder class
class ModeButtonBuilder {
  // Define buildModeButton method
  static Widget buildModeButton(
    String mode,
    String label,
    String iconAsset,
    String selectedIconAsset,
    String modeOfAI,
    Function(String) onModeChanged,
  ) {
    // Define isSelected variable
    bool isSelected = modeOfAI == mode;

    // Return the ModeButton widget
    return SizedBox(
      width: 170,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          onModeChanged(isSelected ? "" : mode);
        },
        // The icon of the button
        icon: Image.asset(
          isSelected ? selectedIconAsset : iconAsset,
          width: 24,
          height: 24,
        ),
        // The label of the button
        label: Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: isSelected ? const Color.fromRGBO(255, 255, 255, 1) : Colors.black,
              fontSize: 14,
            ),
          ),
        ),
        // The style of the button
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color.fromRGBO(152, 149, 198, 1) : null,
        ),
      ),
    );
  }
}
