import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceTicket {
  
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.42.0.1:3000'
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

Future addComment(

    int ticketId,

    Map<String, dynamic> data,

  ) async {

    final headers =
        await getHeaders();

    return await dio.post(

      '/tickets/$ticketId/comment',

      data: data,

      options: Options(
        headers: headers,
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | GET COMMENTS
  |--------------------------------------------------------------------------
  */

  Future<List<dynamic>> getComments(
      int ticketId) async {

    final headers =
        await getHeaders();

    final response = await dio.get(

      '/tickets/$ticketId/comments',

      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  /*
  |--------------------------------------------------------------------------
  | DELETE COMMENT
  |--------------------------------------------------------------------------
  */

  Future deleteComment(
    int commentId,
  ) async {

    final headers =
        await getHeaders();

    return await dio.delete(

      '/comments/$commentId',

      options: Options(
        headers: headers,
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | DELETE TICKET
  |--------------------------------------------------------------------------
  */

  Future deleteTicket(
    int ticketId,
  ) async {

    final headers =
        await getHeaders();

    return await dio.delete(

      '/tickets/$ticketId',

      options: Options(
        headers: headers,
      ),
    );
  }


}
