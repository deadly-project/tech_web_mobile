// splash_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {

    SharedPreferences prefs =
        await SharedPreferences.getInstance();

    String? token = prefs.getString("token");

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    /*
    |--------------------------------------------------------------------------
    | TOKEN EXISTE
    |--------------------------------------------------------------------------
    */

    if (token != null) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) => const DashboardPage(),
        ),
      );

    }

    /*
    |--------------------------------------------------------------------------
    | PAS CONNECTE
    |--------------------------------------------------------------------------
    */

    else {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: CircularProgressIndicator(),
      ),
    );
  }
}