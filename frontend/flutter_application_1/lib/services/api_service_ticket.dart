import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceTicket {
  
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.168.117:3000'
    )
  );

  Future<Map<String, String>> getHeaders() async {

  SharedPreferences prefs =
      await SharedPreferences.getInstance();

  String? token = prefs.getString("token");

  return {

    "Authorization": "Bearer $token"
  };
}

  Future<List<dynamic>> getTickets() async {
  final headers = await getHeaders();   
    final response = await dio.get(
      '/tickets',
      options: Options(headers: headers),
    );


    return response.data;
  }

  Future createTicket(Map<String, dynamic> data) async {
  final headers = await getHeaders();
    return await dio.post('/tickets', data: data,
    options: Options(headers: headers),
    );
  }

  Future updateStatus(int id, String status) async {
    final headers = await getHeaders();
    return await dio.put(
      '/tickets/$id/status',
      data: {
        'statut': status
      },
      options: Options(headers: headers),
    );
  }
}