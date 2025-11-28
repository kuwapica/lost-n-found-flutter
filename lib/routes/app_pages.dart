import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/pages/login/login_binding.dart';
import 'package:lost_and_found/pages/login/login_page.dart';
import 'package:lost_and_found/pages/register/register_binding.dart';
import 'package:lost_and_found/pages/register/register_page.dart';
import 'package:lost_and_found/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    // ini bisa dihapus atau comment, aku bikin biar pas login itu bisa ngarah ke halaman baru
    GetPage(
      name: AppRoutes.home,
      page: () => const Scaffold(body: Center(child: Text("Home Page"))),
    ),
  ];
}
