import 'package:flutter/material.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

// Define StoryboardScreen widget
class StoryboardScreen extends StatelessWidget {
  const StoryboardScreen({super.key});

  // Build the StoryboardScreen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorPink,
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Welcome to MiMi Virtual Assistant!',
              style: headingBricolageGrotesqueFontStyle(),
            ),
            const SizedBox(height: 16.0),
            // Description
            Text(
              'MiMi is a highly intelligent and versatile AI-powered voice assistant designed to improve your daily life and productivity.',
              style: poppinsFontStyle(),
            ),
            const SizedBox(height: 24.0),
            // Key features
            Text(
              'Key Features:',
              style: headingBricolageGrotesqueFontStyle(),
            ),
            const SizedBox(height: 16.0),
            Text(
              '1. Chat Mode:',
              style: poppinsFontStyle(),
            ),
            const SizedBox(height: 8.0),
            Text(
              '- Ask questions and get accurate answers across various domains',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '- Interact using voice commands or typed questions',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '- Get writing assistance, code snippets, and programming guidance',
              style: sidenotePoppinsFontStyle(),
            ),
            const SizedBox(height: 16.0),
            Text(
              '2. Image Generation Mode:',
              style: poppinsFontStyle(),
            ),
            const SizedBox(height: 8.0),
            Text(
              '- Generate creative images based on text descriptions or voice prompts',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '- Download generated images for easy access and sharing',
              style: sidenotePoppinsFontStyle(),
            ),
            const SizedBox(height: 24.0),
            Text(
              'How to Use:',
              style: headingBricolageGrotesqueFontStyle(),
            ),
            const SizedBox(height: 16.0),
            Text(
              '1. Create an account or log in using your email, Google, or Microsoft account.',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '2. Navigate to the home screen and choose between Chat Mode and Image Generation Mode.',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '3. In Chat Mode, type your question or use the microphone button to ask using voice.',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '4. In Image Generation Mode, describe the image you want using text or voice prompts.',
              style: sidenotePoppinsFontStyle(),
            ),
            Text(
              '5. Interact with the generated responses and download images as needed.',
              style: sidenotePoppinsFontStyle(),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Enjoy using MiMi Virtual Assistant to enhance your daily life and boost your productivity!',
              style: poppinsFontStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
