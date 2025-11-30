import 'package:get/get.dart';
import 'package:lost_and_found/controllers/report_controller.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
