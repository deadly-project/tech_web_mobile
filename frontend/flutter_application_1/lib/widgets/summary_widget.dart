import 'package:flutter/material.dart';

class SummaryWidget extends StatelessWidget {
  final double download;
  final double upload;
  final double latency;

  const SummaryWidget({
    super.key,
    required this.download,
    required this.upload,
    required this.latency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Download: ${download.toStringAsFixed(1)} Mbps"),
        Text("Upload: ${upload.toStringAsFixed(1)} Mbps"),
        Text("Ping: ${latency.toStringAsFixed(0)} ms"),
      ],
    );
  }
}