import 'dart:async';

import 'package:flutter/material.dart';

import '../services/speedtest_service.dart';
import '../services/ping_service.dart';

import '../widgets/gauge_widget.dart';
import '../widgets/summary_widget.dart';

class SpeedTestPage extends StatefulWidget {

  const SpeedTestPage({super.key});

  @override
  State<SpeedTestPage> createState() =>
      _SpeedTestPageState();
}

class _SpeedTestPageState
    extends State<SpeedTestPage> {

  /*
  |--------------------------------------------------------------------------
  | VARIABLES
  |--------------------------------------------------------------------------
  */

  double download = 0;

  double upload = 0;

  double latency = 0;

  double latencySum = 0;

  int latencyCount = 0;

  bool running = false;

  /*
  |--------------------------------------------------------------------------
  | SERVICES
  |--------------------------------------------------------------------------
  */

  final speed =
      SpeedTestService(
    "http://10.42.0.1:3000/speedtest",
  );

  final ping = PingService();

  /*
  |--------------------------------------------------------------------------
  | STREAM SUBSCRIPTIONS
  |--------------------------------------------------------------------------
  */

  StreamSubscription? dSub;

  StreamSubscription? pSub;

  /*
  |--------------------------------------------------------------------------
  | START TEST
  |--------------------------------------------------------------------------
  */

  Future<void> startTest() async {

    setState(() {

      running = true;

      download = 0;

      upload = 0;

      latency = 0;

      latencySum = 0;

      latencyCount = 0;
    });

    try {

      /*
      |--------------------------------------------------------------------------
      | LATENCY
      |--------------------------------------------------------------------------
      */

      pSub = ping
          .pingStream()
          .listen((value) {

        setState(() {

          latency = value;

          latencySum += value;

          latencyCount++;
        });
      });

      /*
      |--------------------------------------------------------------------------
      | DOWNLOAD
      |--------------------------------------------------------------------------
      */

      dSub = speed
          .download("50mb.bin")
          .listen(

        (value) {

          setState(() {

            download = value;
          });
        },

        onError: (e) {

          debugPrint(
            "Erreur download : $e",
          );
        },
      );

      /*
      |--------------------------------------------------------------------------
      | DOWNLOAD PENDANT 10s
      |--------------------------------------------------------------------------
      */

      await Future.delayed(
        const Duration(seconds: 10),
      );

      await dSub?.cancel();

      /*
      |--------------------------------------------------------------------------
      | UPLOAD
      |--------------------------------------------------------------------------
      */

      await for (
        final value
            in speed.upload()
      ) {

        setState(() {

          upload = value;
        });
      }

    } catch (e) {

      debugPrint(
        "Erreur speedtest : $e",
      );

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content: Text(
              "Erreur : $e",
            ),

            backgroundColor:
                Colors.red,
          ),
        );
      }

    } finally {

      await pSub?.cancel();

      if (mounted) {

        setState(() {

          running = false;
        });
      }
    }
  }

  /*
  |--------------------------------------------------------------------------
  | AVERAGE LATENCY
  |--------------------------------------------------------------------------
  */

  double get avgLatency {

    if (latencyCount == 0) {

      return 0;
    }

    return latencySum / latencyCount;
  }

  /*
  |--------------------------------------------------------------------------
  | DISPOSE
  |--------------------------------------------------------------------------
  */

  @override
  void dispose() {

    dSub?.cancel();

    pSub?.cancel();

    super.dispose();
  }

  /*
  |--------------------------------------------------------------------------
  | UI
  |--------------------------------------------------------------------------
  */

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Speed Test",
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(
                height: 20,
              ),

              /*
              |--------------------------------------------------------------------------
              | GAUGES
              |--------------------------------------------------------------------------
              */

              Row(

                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,

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

              const SizedBox(
                height: 30,
              ),

              /*
              |--------------------------------------------------------------------------
              | LATENCY
              |--------------------------------------------------------------------------
              */

              Card(

                elevation: 3,

                child: Padding(

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  child: Column(

                    children: [

                      Text(

                        "Latency",

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Colors.grey[700],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        "${latency.toStringAsFixed(0)} ms",

                        style:
                            const TextStyle(

                          fontSize: 28,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(

                        "Moyenne : ${avgLatency.toStringAsFixed(0)} ms",

                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              /*
              |--------------------------------------------------------------------------
              | SUMMARY
              |--------------------------------------------------------------------------
              */

              SummaryWidget(

                download: download,

                upload: upload,

                latency: avgLatency,
              ),

              const SizedBox(
                height: 40,
              ),

              /*
              |--------------------------------------------------------------------------
              | BUTTON
              |--------------------------------------------------------------------------
              */

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  onPressed:
                      running
                          ? null
                          : startTest,

                  style:
                      ElevatedButton
                          .styleFrom(

                    backgroundColor:
                        Colors.blueAccent,

                    shape:
                        RoundedRectangleBorder(

                      borderRadius:
                          BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),

                  child:
                      running

                          ? const Row(

                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,

                              children: [

                                SizedBox(

                                  width: 20,

                                  height: 20,

                                  child:
                                      CircularProgressIndicator(

                                    color:
                                        Colors.white,

                                    strokeWidth:
                                        2,
                                  ),
                                ),

                                SizedBox(
                                  width: 15,
                                ),

                                Text(

                                  "Test en cours...",

                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),
                              ],
                            )

                          : const Text(

                              "Démarrer le test",

                              style:
                                  TextStyle(

                                fontSize: 18,

                                fontWeight:
                                    FontWeight.bold,

                                color:
                                    Colors.white,
                              ),
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}