import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lost_and_found/routes/app_routes.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  
  final isLoading = false.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      userEmail.value = user.email ?? '';
      userName.value = user.userMetadata?['name'] ?? 'Pengguna';
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      isLoading.value = true;

      await supabase.auth.updateUser(
        UserAttributes(
          data: {'name': newName},
        ),
      );

      userName.value = newName;

      Get.snackbar(
        'Berhasil',
        'Nama berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui nama: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      isLoading.value = true;

      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      Get.snackbar(
        'Berhasil',
        'Password berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Get.back(result: true);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui password: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      Get.snackbar(
        'Berhasil',
        'Logout berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }
}