import 'package:socket_io_client/socket_io_client.dart'
    as IO;

import 'notification_service.dart';

class SocketService {

  static late IO.Socket socket;

  static void connect() {

    socket = IO.io(

      "http://10.42.0.1:3000",

      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    /*
    |--------------------------------------------------------------------------
    | CONNECT
    |--------------------------------------------------------------------------
    */

    socket.onConnect((_) {

      print("Socket connecté");
    });

    /*
    |--------------------------------------------------------------------------
    | NEW TICKET
    |--------------------------------------------------------------------------
    */

    socket.on("new-ticket", (data) async {

      print("Nouveau ticket reçu");

      await NotificationService.showNotification(

        id: data["id"] ?? 0,

        title: "Nouveau Ticket",

        body: data["titre"] ?? "Ticket créé",
      );
    });

    /*
    |--------------------------------------------------------------------------
    | DISCONNECT
    |--------------------------------------------------------------------------
    */

    socket.onDisconnect((_) {

      print("Socket déconnecté");
    });
  }
}