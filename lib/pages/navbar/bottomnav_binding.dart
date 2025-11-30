import 'package:get/get.dart';
import 'package:lost_and_found/controllers/bottomnav_controller.dart';
import 'package:lost_and_found/controllers/post_controller.dart';
import 'package:lost_and_found/controllers/profile_controller.dart';

class BottomnavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomnavController>(() => BottomnavController());

    Get.lazyPut<PostController>(
      () => PostController(),
    ); //ini diganti jadi beranda
    Get.lazyPut<PostController>(() => PostController());
    Get.lazyPut<ProfileController>(() => ProfileController()); //udah diganti jadi profile yaw
  }
}
