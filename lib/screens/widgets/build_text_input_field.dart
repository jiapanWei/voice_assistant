import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputField extends StatefulWidget {
  final Function(String) onSearch;

  const TextInputField({super.key, required this.onSearch});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 13.0, right: 13.0, top: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 18.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search ...",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  suffixIcon: InkWell(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        widget.onSearch(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        "images/search_icon.png",
                        width: 24,
                        height: 24,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
