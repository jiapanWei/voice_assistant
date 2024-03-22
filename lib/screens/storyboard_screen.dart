import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'package:voice_assistant/screens/widgets/styles.dart';

class StoryboardScreen extends StatefulWidget {
  const StoryboardScreen({super.key});

  @override
  _StoryboardScreenState createState() => _StoryboardScreenState();
}

class _StoryboardScreenState extends State<StoryboardScreen> {
  String? storyboardPdfPath;

  @override
  void initState() {
    super.initState();
    loadStoryboardPdf();
  }

  Future<void> loadStoryboardPdf() async {
    final tempDir = await getTemporaryDirectory();
    final tempPdfPath = '${tempDir.path}/dummy.pdf';

    final pdfData = await rootBundle.load('assets/dummy.pdf');
    final bytes = pdfData.buffer.asUint8List();

    final file = await File(tempPdfPath).writeAsBytes(bytes, flush: true);

    setState(() {
      storyboardPdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColorPink,
        title: const Text('Help & Support'),
      ),
      body: storyboardPdfPath != null
          ? PDFView(
              filePath: storyboardPdfPath!,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
