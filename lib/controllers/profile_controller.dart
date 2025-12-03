import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lost_and_found/routes/app_routes.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  
  final isLoading = false.obs;
  final isUploadingAvatar = false.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final avatarUrl = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        userEmail.value = user.email ?? '';
        userName.value = user.userMetadata?['name'] ?? 'Pengguna';

        // Munculin avatar dari profiles table
        final response = await supabase
            .from('profiles')
            .select('avatar_url')
            .eq('id', user.id)
            .maybeSingle();

        if (response != null && response['avatar_url'] != null) {
          avatarUrl.value = response['avatar_url'];
        }
      }
    } catch (e) {
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      // Update auth metadata
      await supabase.auth.updateUser(
        UserAttributes(data: {'name': newName}),
      );

      // Update profiles table
      await supabase.from('profiles').upsert({
        'id': user.id,
        'name': newName,
      });

      userName.value = newName;

      Get.snackbar(
        'Berhasil',
        'Nama berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFCD303),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(seconds: 2));
      Get.back();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui nama: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
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
        'Password berhasil disimpan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFCD303),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(seconds: 2));
      Get.back();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadAvatar() async {
    try {
      // Show bottom sheet untuk pilih foto
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (image == null) return;

      // Validasi format file
      final extension = image.path.split('.').last.toLowerCase();
      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        Get.snackbar(
          'Error',
          'Hanya file JPG dan PNG yang diperbolehkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Crop image dengan ratio 1:1
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Foto Profil',
            toolbarColor: const Color(0xFFFCD303),
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),
          IOSUiSettings(
            title: 'Crop Foto Profil',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return;

      // Upload foto
      await _uploadAvatar(File(croppedFile.path));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih foto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadAvatar(File imageFile) async {
    try {
      isUploadingAvatar.value = true;

      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = '${user.id}/$fileName';

      // Delete old avatar if exists
      if (avatarUrl.value != null) {
        try {
          final oldPath = avatarUrl.value!.split('/').last;
          await supabase.storage.from('avatars').remove(['${user.id}/$oldPath']);
        } catch (e) {
        }
      }

      // Upload new avatar
      await supabase.storage.from('avatars').upload(
            path,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get public URL
      final publicUrl = supabase.storage.from('avatars').getPublicUrl(path);

      // Update profiles table
      await supabase.from('profiles').upsert({
        'id': user.id,
        'avatar_url': publicUrl,
        'name': userName.value,
      });

      avatarUrl.value = publicUrl;

      Get.snackbar(
        'Berhasil',
        'Foto Profil Berhasil Diubah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFCD303),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupload foto: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploadingAvatar.value = false;
    }
  }

  void showAvatarPickerBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Color(0xFFFCD303),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            const Text(
              'Foto Profil',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFCD303),
              ),
            ),
            const SizedBox(height: 24),
            
            // Pick from gallery button
            GestureDetector(
            onTap: () {
              Get.back();
              pickAndUploadAvatar();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.photo_library,
                    color: Color(0xFFFCD303),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Galeri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFCD303),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
    isDismissible: true,
    enableDrag: true,
  );
}

  Future<void> logout() async {
    try {
      await supabase.auth.signOut();
      Get.snackbar(
        'Berhasil',
        'Logout berhasil!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFCD303),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal logout: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
}