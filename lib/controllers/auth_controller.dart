import 'package:get/get.dart';
import 'package:lost_and_found/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  final isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  bool _isSigningUp = false;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = supabase.auth.currentUser;

    supabase.auth.onAuthStateChange.listen((data) {
      currentUser.value = data.session?.user;

      if (data.session?.user != null && !_isSigningUp) {
        Get.offAllNamed(AppRoutes.navbottom);
      } else if (data.session?.user == null && !_isSigningUp) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user != null) {
        Get.snackbar(
          'Berhasil',
          'Login berhasil!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 1500),
        );

        Get.offAllNamed(AppRoutes.navbottom);
      }
    } on AuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      _isSigningUp = true;

      final response = await supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'name': name.trim()},
      );

      if (response.session != null) {
        await supabase.auth.signOut();
      }

      _isSigningUp = false;

      Get.snackbar(
        'Berhasil',
        'Pendaftaran berhasil! Silakan login dengan akun yang telah anda buat.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(microseconds: 3),
      );

      Get.offAllNamed(AppRoutes.login);
    } on AuthException catch (e) {
      _isSigningUp = false;
      Get.snackbar(
        'Error',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      _isSigningUp = false;
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
      Get.snackbar(
        'Berhasil',
        'Logout berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Navigate to login page
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

  bool get isLoggedIn => currentUser.value != null;
}
