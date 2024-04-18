import 'package:logger/logger.dart';

// Define LoggerStyle class
class LoggerStyle {
  // Define getLogger method
  static Logger getLogger() {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: false,
      ),
    );
  }
}
