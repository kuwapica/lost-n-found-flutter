import 'package:flutter/material.dart';
import 'package:lost_and_found/controllers/auth_controller.dart';
import 'package:lost_and_found/routes/app_pages.dart';
import 'package:lost_and_found/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://doutdtwyrxaaqxttjgwx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRvdXRkdHd5cnhhYXF4dHRqZ3d4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyMDg4MDYsImV4cCI6MjA3OTc4NDgwNn0.dNVUKW942atDr1ZIAt0jrJenkX2EV5aPEWvr_G5GbMY',
  );

  Get.put(AuthController(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lost n Found',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}
