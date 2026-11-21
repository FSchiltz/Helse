import 'package:logger/logger.dart';

final appLogger = Logger(
  filter: ProductionFilter(),
  level: Level.info,
  output: ConsoleOutput(),
  printer: SimplePrinter(colors: true),
);
