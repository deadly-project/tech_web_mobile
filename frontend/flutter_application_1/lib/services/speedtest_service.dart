import 'dart:io';
import 'dart:async';

    // final request = await client.postUrl(
    //   Uri.parse("$baseUrl/upload"),
    // );
class SpeedTestService {
  final String baseUrl;

  SpeedTestService(this.baseUrl);

  Stream<double> download(String file) async* {
    final client = HttpClient();

    final request = await client.getUrl(
      Uri.parse("$baseUrl/download/$file"),
    );

    final response = await request.close();

    int bytes = 0;
    final stopwatch = Stopwatch()..start();

    await for (var chunk in response) {
      bytes += chunk.length;

      final sec = stopwatch.elapsedMilliseconds / 1000;
      if (sec > 0) {
        yield (bytes * 8) / sec / (1024 * 1024);
      }
    }
  }

  Future<double> upload() async {
    final client = HttpClient();

  final request = await client.postUrl(
    Uri.parse("$baseUrl/upload"),
  );

  final data = List<int>.generate(1024 * 50, (i) => i % 256); // petit chunk

  int totalBytes = 0;
  final stopwatch = Stopwatch()..start();

  final completer = Completer<double>();

  // ⏱ arrêt après 10 secondes
  Timer(const Duration(seconds: 10), () async {
    try {
      await request.close();

      final sec = stopwatch.elapsedMilliseconds / 1000;

      final mbps = (totalBytes * 8) / sec / (1024 * 1024);

      if (!completer.isCompleted) {
        completer.complete(mbps);
      }
    } catch (_) {}
  });

  // 🔥 ENVOI CONTINU PENDANT 10s
  while (stopwatch.elapsedMilliseconds < 10000) {
    request.add(data);
    totalBytes += data.length;

    await Future.delayed(const Duration(milliseconds: 150));
  }

  await request.close();

  return completer.future;
  }
}