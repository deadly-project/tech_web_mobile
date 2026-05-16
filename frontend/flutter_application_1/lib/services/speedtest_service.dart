import 'dart:async';
import 'dart:io';

class SpeedTestService {

  final String baseUrl;

  SpeedTestService(this.baseUrl);

  /*
  |--------------------------------------------------------------------------
  | DOWNLOAD TEST
  |--------------------------------------------------------------------------
  */

  Stream<double> download(String file) async* {

    final client = HttpClient();

    try {

      final request = await client.getUrl(
        Uri.parse("$baseUrl/download/$file"),
      );

      final response = await request.close();

      int bytes = 0;

      final stopwatch = Stopwatch()
        ..start();

      await for (var chunk in response) {

        bytes += chunk.length;

        final sec =
            stopwatch.elapsedMilliseconds /
                1000;

        if (sec > 0) {

          final mbps =
              (bytes * 8) /
              sec /
              (1024 * 1024);

          yield mbps;
        }
      }

    } catch (e) {

      throw Exception(
        "Erreur download : $e",
      );

    } finally {

      client.close();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | UPLOAD TEST
  |--------------------------------------------------------------------------
  */

  Stream<double> upload() async* {

    final client = HttpClient();

    try {

      final request =
          await client.postUrl(
        Uri.parse("$baseUrl/upload"),
      );

      /*
      |--------------------------------------------------------------------------
      | DONNÉES ENVOYÉES
      |--------------------------------------------------------------------------
      */

      final data =
          List<int>.generate(
        1024 * 50,
        (i) => i % 256,
      );

      int totalBytes = 0;

      final stopwatch = Stopwatch()
        ..start();

      /*
      |--------------------------------------------------------------------------
      | ENVOI CONTINU PENDANT 10s
      |--------------------------------------------------------------------------
      */

      while (
          stopwatch.elapsedMilliseconds <
              10000) {

        request.add(data);

        totalBytes += data.length;

        final sec =
            stopwatch.elapsedMilliseconds /
                1000;

        if (sec > 0) {

          final mbps =
              (totalBytes * 8) /
              sec /
              (1024 * 1024);

          yield mbps;
        }

        await Future.delayed(
          const Duration(
            milliseconds: 100,
          ),
        );
      }

      /*
      |--------------------------------------------------------------------------
      | FIN REQUÊTE
      |--------------------------------------------------------------------------
      */

      await request.close();

    } catch (e) {

      throw Exception(
        "Erreur upload : $e",
      );

    } finally {

      client.close();
    }
  }
}