import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_and_found/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportController extends GetxController {
  final supabase = Supabase.instance.client;
  final isLoading = false.obs;

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  String itemType = '';

  @override
  void onInit() {
    super.onInit();
    itemType = Get.arguments['type'] ?? 'lost';
  }

  bool get hasChanges {
    return nameController.text.isNotEmpty ||
        locationController.text.isNotEmpty ||
        dateController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        selectedImage.value != null;
  }

  Future<bool> onWillPop() async {
    if (hasChanges) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text(
            'Konfirmasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus draft laporan?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Ya, Hapus'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
      return result ?? false;
    }
    return true;
  }

  Future<void> handleCancel() async {
    final shouldPop = await onWillPop();
    if (shouldPop) {
      Get.back();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    locationController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dateController.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  Future<void> submitReport() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (nameController.text.isEmpty ||
        locationController.text.isEmpty ||
        dateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Mohon lengkapi semua field',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      String? imageUrl;

      if (selectedImage.value != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = '${supabase.auth.currentUser!.id}/$fileName';

        await supabase.storage.from('items').upload(path, selectedImage.value!);
        imageUrl = supabase.storage.from('items').getPublicUrl(path);
      }

      await supabase.from('items').insert({
        'user_id': supabase.auth.currentUser!.id,
        'name': nameController.text.trim(),
        'location': locationController.text.trim(),
        'date': dateController.text.trim(),
        'description': descriptionController.text.trim(),
        'type': itemType,
        'image_url': imageUrl,
        'status': 'active',
      });

      isLoading.value = false;

      Get.offAllNamed(AppRoutes.navbottom);

      Get.snackbar(
        'Berhasil',
        'Laporan berhasil ditambahkan',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Gagal menambahkan laporan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
