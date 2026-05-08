import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:dart_ping/dart_ping.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double downloadSpeed = 0;
  double uploadSpeed = 0;
  double latency = 0;

  bool isTesting = false;
  String status = "Idle";

  Timer? pingTimer;
  List<double> latencySamples = [];

  // ===================== LATENCY LIVE =====================
  void startLivePing() {
    latencySamples.clear();

    pingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        try {
          final ping = Ping('google.com', count: 1);

          await for (final event in ping.stream) {
            if (event.response != null) {
              final ms =
                  event.response!.time?.inMilliseconds.toDouble();

              if (ms != null) {
                setState(() {
                  latency = ms; // LIVE VALUE
                });

                latencySamples.add(ms);
              }
            }
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      },
    );
  }

  void stopLivePing() {
    pingTimer?.cancel();

    if (latencySamples.isNotEmpty) {
      final avg =
          latencySamples.reduce((a, b) => a + b) /
              latencySamples.length;

      setState(() {
        latency = avg; // FINAL AVERAGE
      });
    }
  }

  // ===================== DOWNLOAD 10s =====================
  Future<double> testDownload10s() async {
    setState(() {
      status = "Download en cours...";
    });

    final client = HttpClient();

    final request = await client.getUrl(
      Uri.parse('https://proof.ovh.net/files/80Mb.dat'),
    );

    final response = await request.close();

    int totalBytes = 0;

    final stopwatch = Stopwatch()..start();

    final completer = Completer<double>();

    Timer(const Duration(seconds: 10), () {
      completer.complete(
        (totalBytes * 8) /
            (stopwatch.elapsedMilliseconds / 1000) /
            (1024 * 1024),
      );
    });

    await for (var chunk in response) {
      totalBytes += chunk.length;

      final seconds = stopwatch.elapsedMilliseconds / 1000;

      if (seconds > 0) {
        final mbps =
            ((totalBytes * 8) / seconds) / (1024 * 1024);

        setState(() {
          downloadSpeed = mbps;
        });
      }

      if (stopwatch.elapsedMilliseconds >= 10000) {
        break;
      }
    }

    return completer.future;
  }

  // ===================== UPLOAD 10s =====================
  Future<double> testUpload10s() async {
    setState(() {
      status = "Upload en cours...";
    });

    final client = HttpClient();

    final request = await client.postUrl(
      Uri.parse('https://httpbin.org/post'),
    );

    final data =
        List<int>.generate(1024 * 500, (i) => i % 256);

    int totalBytes = 0;

    final stopwatch = Stopwatch()..start();

    final completer = Completer<double>();

    Timer(const Duration(seconds: 10), () {
      completer.complete(
        (totalBytes * 8) /
            (stopwatch.elapsedMilliseconds / 1000) /
            (1024 * 1024),
      );
    });

    request.add(data);
    totalBytes += data.length;

    final response = await request.close();
    await response.drain();

    setState(() {
      uploadSpeed =
          ((data.length * 8) /
              (stopwatch.elapsedMilliseconds / 1000)) /
          (1024 * 1024);
    });

    return completer.future;
  }

  // ===================== MAIN TEST =====================
  Future<void> startSpeedTest() async {
    setState(() {
      isTesting = true;
      downloadSpeed = 0;
      uploadSpeed = 0;
      status = "Démarrage...";
    });

    try {
      startLivePing(); // 🔥 LATENCY LIVE START

      await testDownload10s();

      await testUpload10s();

      stopLivePing(); // 🔥 LATENCY STOP + AVERAGE

      setState(() {
        status = "Test terminé";
      });

    } catch (e) {
      debugPrint(e.toString());
      stopLivePing();

      setState(() {
        status = "Erreur";
      });
    }

    setState(() {
      isTesting = false;
    });
  }

  // ===================== GAUGE =====================
  Widget buildGauge({
    required String title,
    required double value,
    required String unit,
    required Color color,
    double max = 10,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          width: 180,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: max,
                ranges: [
                  GaugeRange(
                    startValue: 0,
                    endValue: max,
                    color: color.withOpacity(0.3),
                  )
                ],
                pointers: [
                  NeedlePointer(
                    value: value,
                    needleColor: color,
                    knobStyle: KnobStyle(color: color),
                  )
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Text(
                      '${value.toStringAsFixed(1)} $unit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.5,
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Réseau'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              'Test de Débit & Latence',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              status,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildGauge(
                  title: 'Download',
                  value: downloadSpeed,
                  unit: 'Mbps',
                  color: Colors.green,
                ),
                buildGauge(
                  title: 'Upload',
                  value: uploadSpeed,
                  unit: 'Mbps',
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Latence Réseau',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${latency.toStringAsFixed(0)} ms',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.cyan,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: isTesting ? null : startSpeedTest,
              icon: const Icon(Icons.network_check),
              label: Text(
                isTesting ? 'Test en cours...' : 'Lancer le test',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
