import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class GaugeWidget extends StatelessWidget {
  final String title;
  final double value;
  final String unit;
  final Color color;

  const GaugeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),

        SizedBox(
          height: 200,
          width: 200,
          child: SfRadialGauge(
            axes: [
              RadialAxis(
                minimum: 0,
                maximum: 100,
                pointers: [
                  NeedlePointer(
                    value: value,
                    needleColor: color,
                  )
                ],
                annotations: [
                  GaugeAnnotation(
                    widget: Text(
                      "${value.toStringAsFixed(1)} $unit",
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
}