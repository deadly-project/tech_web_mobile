import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /*
  |--------------------------------------------------------------------------
  | INITIALISATION
  |--------------------------------------------------------------------------
  */

  static Future<void> init() async {

    const AndroidInitializationSettings
        androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
        initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  /*
  |--------------------------------------------------------------------------
  | AFFICHER NOTIFICATION
  |--------------------------------------------------------------------------
  */

  static Future<void> showNotification({

    required int id,

    required String title,

    required String body,

  }) async {

    const AndroidNotificationDetails
        androidDetails =
        AndroidNotificationDetails(

      'ticket_channel',

      'Tickets',

      channelDescription:
          'Notifications des tickets réseau',

      importance: Importance.max,

      priority: Priority.high,
    );

    const NotificationDetails
        notificationDetails =
        NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(

      id: id,

      title: title,

      body: body,

      notificationDetails:
          notificationDetails,
    );
  }
}