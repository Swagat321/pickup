import "package:logger/logger.dart";

// Singleton class housing logger instance
class Log {
  static final Logger _logger = Logger();

  static void init(Level level) {
    Logger.level = level;
  }

  static void trace(dynamic message) {
    _logger.t(message);
  }

  static void debug(dynamic message) {
    _logger.d(message);
  }

  static void info(dynamic message) {
    _logger.i(message);
  }

  static void error(dynamic message, Object error) {
    _logger.e(message, error: error);
  }

  static void wtf(dynamic message, Object error) {
    _logger.f(message, error: error);
  }

}
