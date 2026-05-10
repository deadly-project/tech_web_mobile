import 'dart:async';

import 'package:flutter/material.dart';
import '../services/speedtest_service.dart';
import '../services/ping_service.dart';
import '../widgets/gauge_widget.dart';
import '../widgets/summary_widget.dart';

class SpeedTestPage extends StatefulWidget {
  const SpeedTestPage({super.key});

  @override
  State<SpeedTestPage> createState() => _SpeedTestPageState();
}

class _SpeedTestPageState extends State<SpeedTestPage> {
  double download = 0;
  double upload = 0;
  double latency = 0;

  double latencySum = 0;
  int latencyCount = 0;

  bool running = false;

  final speed = SpeedTestService("http://192.168.168.117:3000/speedtest");
  final ping = PingService();

  StreamSubscription? dSub;
  StreamSubscription? pSub;

  Future<void> startTest() async {
    setState(() {
      running = true;
      download = 0;
      upload = 0;
      latency = 0;
      latencySum = 0;
      latencyCount = 0;
    });

    // LATENCY
    pSub = ping.pingStream().listen((value) {
      setState(() {
        latency = value;
        latencySum += value;
        latencyCount++;
      });
    });

    // DOWNLOAD
    dSub = speed.download("50mb.bin").listen((value) {
      setState(() => download = value);
    });

    await Future.delayed(const Duration(seconds: 10));
    await dSub?.cancel();

    // UPLOAD
    upload = await speed.upload();

    await pSub?.cancel();

    setState(() {
      running = false;
    });
  }

  double get avgLatency =>
      latencyCount == 0 ? 0 : latencySum / latencyCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Speed Test")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GaugeWidget(
                title: "Download",
                value: download,
                unit: "Mbps",
                color: Colors.green,
              ),
              GaugeWidget(
                title: "Upload",
                value: upload,
                unit: "Mbps",
                color: Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text("Latency: ${latency.toStringAsFixed(0)} ms"),
          Text("Avg: ${avgLatency.toStringAsFixed(0)} ms"),

          const SizedBox(height: 20),

          SummaryWidget(
            download: download,
            upload: upload,
            latency: avgLatency,
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: running ? null : startTest,
            child: Text(running ? "Testing..." : "Start"),
          ),
        ],
      ),
    );
  }
}