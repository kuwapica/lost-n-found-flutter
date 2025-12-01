import 'package:get/get.dart';
import 'package:lost_and_found/controllers/other_user_profile_controller.dart';

class OtherUserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherUserProfileController>(() => OtherUserProfileController());
  }
}
