import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/controllers/auth_controller.dart';
import 'package:lost_and_found/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    Get.put(AuthController());

    await Future.delayed(const Duration(seconds: 1));

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Get.offAllNamed(AppRoutes.navbottom);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'LOST N ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'FOUND',
                    style: TextStyle(
                      color: Color(0xFFFCD303),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
