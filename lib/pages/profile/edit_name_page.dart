import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/controllers/profile_controller.dart';

class EditNamePage extends GetView<ProfileController> {
  const EditNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: controller.userName.value);
    final formKey = GlobalKey<FormState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        if (nameController.text != controller.userName.value) {
          Get.snackbar(
            'Peringatan',
            'Perubahan belum disimpan',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          await Future.delayed(const Duration(milliseconds: 500));
        }
        Get.back();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (nameController.text != controller.userName.value) {
                Get.snackbar(
                  'Peringatan',
                  'Perubahan belum disimpan',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
                Future.delayed(const Duration(milliseconds: 500), () => Get.back());
              } else {
                Get.back();
              }
            },
          ),
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'LOST N ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: 'FOUND',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // Nama Field
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                
                // Save Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                controller.updateUserName(nameController.text.trim());
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFCD303),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black,
                                ),
                              ),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}