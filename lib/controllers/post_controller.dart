import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../routes/app_routes.dart';

class PostController extends GetxController {
  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  void goToReportForm(String type) {
    Get.toNamed(AppRoutes.report, arguments: {'type': type});
  }
}
