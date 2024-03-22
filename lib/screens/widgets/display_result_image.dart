import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/scheduler.dart';

class DisplayResultImage extends StatefulWidget {
  final String imageUrlFromAI;
  final Function(String) getPublicDirectoryPath;

  const DisplayResultImage({
    super.key,
    required this.imageUrlFromAI,
    required this.getPublicDirectoryPath,
  });

  @override
  DisplayResultImageState createState() => DisplayResultImageState();
}

class DisplayResultImageState extends State<DisplayResultImage> {
  bool isDownloadComplete = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 225,
      child: Column(
        children: [
          SizedBox(
            width: 225,
            child: Image.network(widget.imageUrlFromAI),
          ),
          const SizedBox(
            height: 14,
          ),
          SizedBox(
            width: 230,
            child: ElevatedButton(
              onPressed: () async {
                // ... (下载图片逻辑)
                // final imageUrl = imageUrlFromAI;
                final imageName = 'downloaded_image.jpg'; //
                // final picturesDirectoryPath =
                //     await getExternalStorageDirectoryPath();
                final publicDirectoryPath =
                    await widget.getPublicDirectoryPath('Pictures');

                if (publicDirectoryPath != null) {
                  final taskId = await FlutterDownloader.enqueue(
                    url: widget.imageUrlFromAI,
                    savedDir: publicDirectoryPath,
                    showNotification: true,
                    openFileFromNotification: false,
                    fileName: imageName,
                  );

                  final downloadTask =
                      await FlutterDownloader.loadTasksWithRawQuery(
                          query: "SELECT * FROM task WHERE task_id='" +
                              taskId! +
                              "'");
                  if (downloadTask != null && downloadTask.isNotEmpty) {
                    final taskDetails = downloadTask.first;
                    final savedDir = taskDetails.savedDir ?? '';
                    final filename = taskDetails.filename ?? '';
                    final filePath = '$savedDir/$filename';

                    if (filePath.isNotEmpty) {
                      final result = await ImageGallerySaver.saveFile(filePath);
                      print('Image saved to gallery: $result');
                      setState(() {
                        isDownloadComplete = true;
                      });
                    } else {
                      print(
                          'File path is empty. Cannot save image to gallery.');
                    }
                  }
                  if (isDownloadComplete) {
                    SchedulerBinding.instance?.addPostFrameCallback(
                      (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(Icons.check_circle,
                                    color: Color.fromARGB(255, 173, 173, 255)),
                                SizedBox(width: 8),
                                Text(
                                  'Image downloaded successfully!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Arial",
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 129, 129, 230),
                          ),
                        );
                        isDownloadComplete = false;
                      },
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Failed to get external storage directory.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(152, 149, 198, 1),
              ),
              child: Text(
                "Download",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
