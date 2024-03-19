// display_result_rich_text.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisplayResultRichText extends StatelessWidget {
  final String text;
  final Color color;

  const DisplayResultRichText({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

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
