import 'package:get/get.dart';
import 'package:lost_and_found/controllers/auth_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AuthController>();
  }
}
