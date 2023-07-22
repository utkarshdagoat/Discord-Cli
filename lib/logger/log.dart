
import 'package:mason_logger/mason_logger.dart';

class Logs {
  static final logger = Logger(level: Level.verbose, theme: LogTheme());
  static late Progress progress;
  static Future<void> intialProg({String message = ''}) async {
    progress = logger.progress(message);
  }

  static Future<void> waiting({required String message}) async {
    progress.update(message);
  }
}
