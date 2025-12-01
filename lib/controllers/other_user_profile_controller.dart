import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtherUserProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  var userName = 'Memuat...'.obs;
  var userEmail = ''.obs;
  var userAvatarUrl = ''.obs;
  var isLoadingProfile = true.obs;

  var userLostItems = <Map<String, dynamic>>[].obs;
  var userFoundItems = <Map<String, dynamic>>[].obs;
  var isLoadingItems = true.obs;

  late String targetUserId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['userId'] != null) {
      targetUserId = Get.arguments['userId'];
      fetchUserProfile();
      fetchUserItems();
    } else {
      Get.snackbar('Error', 'User ID tidak ditemukan');
      Get.back();
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoadingProfile(true);
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', targetUserId)
          .single();

      userName.value = data['name'] ?? 'Tanpa Nama';
      userEmail.value = data['email'] ?? '';
      userAvatarUrl.value = data['avatar_url'] ?? '';
    } catch (e) {
      userName.value = 'User Tidak Dikenal';
    } finally {
      isLoadingProfile(false);
    }
  }

  Future<void> fetchUserItems() async {
    try {
      isLoadingItems(true);

      final lostData = await supabase
          .from('items')
          .select()
          .eq('user_id', targetUserId)
          .eq('type', 'lost')
          .order('created_at', ascending: false);

      userLostItems.assignAll(List<Map<String, dynamic>>.from(lostData));

      final foundData = await supabase
          .from('items')
          .select()
          .eq('user_id', targetUserId)
          .eq('type', 'found')
          .order('created_at', ascending: false);

      userFoundItems.assignAll(List<Map<String, dynamic>>.from(foundData));
    } catch (e) {
      print('Error fetching user items: $e');
    } finally {
      isLoadingItems(false);
    }
  }

  String getTimeAgo(String timestamp) {
    try {
      final itemDate = DateTime.parse(timestamp);
      final duration = DateTime.now().difference(itemDate);
      if (duration.inDays > 0) return '${duration.inDays} hari yang lalu';
      if (duration.inHours > 0) return '${duration.inHours} jam yang lalu';
      if (duration.inMinutes > 0)
        return '${duration.inMinutes} menit yang lalu';
      return 'Baru saja';
    } catch (_) {
      return '';
    }
  }
}
