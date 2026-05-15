import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
//import 'screens/login_page.dart';
//import 'screens/SpeedTest_page.dart';
//import 'screens/ticket_detail_page.dart';
//import 'screens/create_ticket_page.dart';
import 'services/notification_service.dart';
void main() async{
  
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Réseau',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      //home: LoginPage(), // 👈 page de départ
      //home: SpeedTestPage(),
      //home:CreateTicketPage()
      // home: TicketDetailPage(),
    );
  }
}
