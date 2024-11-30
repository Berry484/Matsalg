import 'package:logger/logger.dart';

final Logger logger = Logger(
  level: Level.debug,
);

class CustomPrinter extends LogPrinter {
  final String className;

  CustomPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final message = event.message;
    return ['$className: $message'];
  }
}
