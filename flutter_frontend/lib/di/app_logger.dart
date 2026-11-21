import 'package:logger/logger.dart';

final appLogger = Logger(
  output: ConsoleOutput(),
  printer: SimplePrinter(colors: true),
);
