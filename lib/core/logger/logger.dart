import 'package:logger/logger.dart';

class GcpLog {
  final Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  void error({String? message, StackTrace? stack}) {
    logger.e(message, stackTrace: stack);
  }

  void info({String? message, StackTrace? stack}) {
    logger.i(message, stackTrace: stack);
  }

  void warn({String? message, StackTrace? stack}) {
    logger.w(message, stackTrace: stack);
  }
}

final GcpLog logger = GcpLog();
