// lib/controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  // Supabase client instance
  final supabase = Supabase.instance.client;

  // Observables untuk menyimpan daftar barang hilang dan ditemukan
  var lostItems = <Map<String, dynamic>>[].obs;
  var foundItems = <Map<String, dynamic>>[].obs;

  // Status loading
  var isLoadingLost = true.obs;
  var isLoadingFound = true.obs;

  // Tab yang sedang aktif (0: Lost, 1: Found)
  var currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data lost dan found saat controller diinisialisasi
    fetchLostItems();
    fetchFoundItems();
  }

  // --- Fungsi untuk Mengambil Barang HILANG ---
  Future<void> fetchLostItems() async {
    try {
      isLoadingLost(true);
      // Ganti 'items' dengan nama tabel barang hilang Anda
      final data = await supabase
          .from('items')
          .select()
          .eq('type', 'lost')
          .order('created_at', ascending: false);

      lostItems.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat barang hilang: $e',
        snackPosition: SnackPosition.BOTTOM,
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoadingLost(false);
    }
  }

  // --- Fungsi untuk Mengambil Barang DITEMUKAN ---
  Future<void> fetchFoundItems() async {
    try {
      isLoadingFound(true);
      // Ganti 'items' dengan nama tabel barang ditemukan Anda
      final data = await supabase
          .from('items')
          .select()
          .eq('type', 'found')
          .order('created_at', ascending: false);

      foundItems.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat barang ditemukan: $e',
        snackPosition: SnackPosition.BOTTOM,
        // ignore: deprecated_member_use
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoadingFound(false);
    }
  }

  // Fungsi untuk menghitung waktu yang lalu (e.g., '3 hari yang lalu')
  String getTimeAgo(String timestamp) {
    try {
      final itemDate = DateTime.parse(timestamp);
      final duration = DateTime.now().difference(itemDate);
      if (duration.inDays > 0) {
        return '${duration.inDays} hari yang lalu';
      } else if (duration.inHours > 0) {
        return '${duration.inHours} jam yang lalu';
      } else if (duration.inMinutes > 0) {
        return '${duration.inMinutes} menit yang lalu';
      } else {
        return 'Baru saja';
      }
    } catch (_) {
      return 'Waktu tidak diketahui';
    }
  }

  // Fungsi untuk navigasi Bottom Nav Bar
  void changePage(int index) {
    // Misalnya, menggunakan switch-case untuk navigasi
    switch (index) {
      case 0:
        // Sudah di Home, mungkin refresh data atau tetap di tempat
        if (currentTabIndex.value != 0) {
          // Navigasi ke Home jika belum di tab Home
          // Dalam konteks ini, Home adalah halaman ini
          // Logika untuk tabbar (Lost/Found) ditangani oleh DefaultTabController di View
        }
        break;
      case 1:
        // Navigasi ke Halaman Post/Form
        Get.toNamed(AppRoutes.post);
        // Pastikan AppRoutes.post sudah didefinisikan
        break;
      case 2:
        // Navigasi ke Halaman Profile
        Get.toNamed(AppRoutes.profile);
        // Pastikan AppRoutes.profile sudah didefinisikan
        break;
    }
  }
}
