import 'package:dio/dio.dart';

class ApiServiceTicket {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.168.117:3000'
    )
  );

  Future<List<dynamic>> getTickets() async {

    final response = await dio.get('/tickets');

    return response.data;
  }

  Future createTicket(Map<String, dynamic> data) async {

    return await dio.post('/tickets', data: data);
  }

  Future updateStatus(String id, String status) async {

    return await dio.put(
      '/tickets/$id/status',
      data: {
        'statut': status
      }
    );
  }
}