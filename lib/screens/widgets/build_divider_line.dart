import 'package:flutter/material.dart';

// Define DividerLine widget that used for the divider line
class DividerLine extends StatelessWidget {
  const DividerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 18),
      child: const Row(
        children: [
          Expanded(child: Divider(color: Colors.grey)),
          Text(
            " OR ",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 10,
            ),
          ),
          Expanded(child: Divider(color: Colors.grey)),
        ],
      ),
    );
  }
}
