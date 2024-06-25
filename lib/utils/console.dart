import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

mixin Console {
  static final Logger _log = Logger(filter: _LogFilter());

  static void logV(dynamic message) => _log.v(message);

  static void logD(dynamic message) => _log.d(message);

  static void logI(dynamic message) => _log.i(message);

  static void logW(dynamic message) => _log.w(message);

  static void logE(dynamic message) => _log.e(message);
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => !kReleaseMode;
}
