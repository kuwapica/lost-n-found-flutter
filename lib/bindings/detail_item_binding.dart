import 'package:get/get.dart';
import 'package:lost_and_found/controllers/detail_item_controller.dart';

class DetailItemBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailItemController>(() => DetailItemController());
  }
}