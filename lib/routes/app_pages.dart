import 'package:get/get.dart';
import 'package:lost_and_found/pages/login/login_binding.dart';
import 'package:lost_and_found/pages/login/login_page.dart';
import 'package:lost_and_found/pages/navbar/bottom_navbar.dart';
import 'package:lost_and_found/pages/navbar/bottomnav_binding.dart';
import 'package:lost_and_found/pages/post/lost_found_form.dart';
import 'package:lost_and_found/pages/post/report_binding.dart';
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
    GetPage(
      name: AppRoutes.navbottom,
      page: () => BottomNavbar(),
      binding: BottomnavBinding(),
    ),
    // GetPage(
    //   name: AppRoutes.post,
    //   page: () => const PostPage(),
    //   binding: PostBinding(),
    // ),
    GetPage(
      name: AppRoutes.report,
      page: () => const LostFoundForm(),
      binding: ReportBinding(),
    ),
  ];
}
