import 'dart:async';
import 'package:dart_ping/dart_ping.dart';

class PingService {
  Stream<double> pingStream() async* {
    while (true) {
      final ping = Ping('google.com', count: 1);

      await for (final event in ping.stream) {
        final ms = event.response?.time?.inMilliseconds.toDouble();
        if (ms != null) yield ms;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }
}