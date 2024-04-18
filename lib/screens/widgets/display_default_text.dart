import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define DisplayResultRichText widget that used for displaying a rich text with a predefined style
class DisplayResultRichText extends StatelessWidget {
  // Define the variables
  final String text;
  final Color color;

  // Define DisplayResultRichText constructor
  const DisplayResultRichText({
    super.key,
    required this.text,
    required this.color,
  });

  // Build the DisplayResultRichText widget
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'I\'m MiMi, your AI assistant!\n',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(97, 42, 116, 1.0),
                  ),
                ),
              ),
            ),
          ),
          TextSpan(
            text: text,
            style: GoogleFonts.poppins(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
