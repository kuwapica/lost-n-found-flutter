import 'package:get/get.dart';
import 'package:lost_and_found/controllers/auth_controller.dart';
import 'package:lost_and_found/controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
