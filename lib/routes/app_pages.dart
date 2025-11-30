import 'package:get/get.dart';
import 'package:lost_and_found/pages/post/lost_found_form.dart';
import 'package:lost_and_found/pages/post/report_binding.dart';
import 'package:lost_and_found/routes/app_routes.dart';
import 'package:lost_and_found/pages/login/login_binding.dart';
import 'package:lost_and_found/pages/login/login_page.dart';
import 'package:lost_and_found/pages/navbar/bottom_navbar.dart';
import 'package:lost_and_found/pages/navbar/bottomnav_binding.dart';
import 'package:lost_and_found/pages/register/register_binding.dart';
import 'package:lost_and_found/pages/register/register_page.dart';
import 'package:lost_and_found/views/detail_item_view.dart';
import 'package:lost_and_found/bindings/detail_item_binding.dart';

// Import Profile pages
import 'package:lost_and_found/pages/profile/profile_page.dart';
import 'package:lost_and_found/pages/profile/edit_profile_page.dart';
import 'package:lost_and_found/pages/profile/edit_name_page.dart';
import 'package:lost_and_found/pages/profile/edit_password_page.dart';
import 'package:lost_and_found/pages/profile/profile_binding.dart';

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
    GetPage(
      name: AppRoutes.detailItem,
      page: () => DetailItemView(),
      binding: DetailItemBinding(),
    ),
    GetPage(
      name: AppRoutes.report,
      page: () => const LostFoundForm(),
      binding: ReportBinding(),
    ),

    // Profile routes
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editName,
      page: () => const EditNamePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.editPassword,
      page: () => const EditPasswordPage(),
      binding: ProfileBinding(),
    ),
  ];
}
