import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailItemController extends GetxController {
  final supabase = Supabase.instance.client;
  var itemDetail = Rx<Map<String, dynamic>?>(null); // Observable untuk detail item
  var isLoading = true.obs;
  var userName = 'Memuat...'.obs;

  var comments = <Map<String, dynamic>>[].obs;
  var isCommentsLoading = true.obs;
  final commentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Ambil ID item dari argumen GetX
    final String itemId = Get.arguments['id']; 
    fetchItemDetail(itemId);
    fetchComments(itemId);
  }

  Future<void> fetchItemDetail(String itemId) async {
    try {
      isLoading(true);
      // Asumsi semua item (lost/found) ada di tabel 'items'
      final data = await supabase
          .from('items')
          .select('*')
          .eq('id', itemId) // Filter berdasarkan ID item
          .single(); // Mengambil satu baris data

      itemDetail(data); // Update observable
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail barang: $e',
                   snackPosition: SnackPosition.BOTTOM,
                   backgroundColor: Get.theme.colorScheme.error.withOpacity(0.8),
                   colorText: Colors.white);
      itemDetail(null); // Set ke null jika ada error
    } finally {
      isLoading(false);
    }
    if (itemDetail.value != null) {
      _fetchUserName(itemDetail.value!['user_id'] as String); // Panggil fungsi ambil nama
    }
  }

  Future<void> _fetchUserName(String itemUserId) async {
    final currentUser = supabase.auth.currentUser;

    if (currentUser != null && currentUser.id == itemUserId) {
      // 1. LOGIC UNTUK USER YANG SEDANG LOGIN (Menggunakan metadata)
      String? namaDariMetadata = currentUser.userMetadata?['full_name'] ?? currentUser.userMetadata?['name'];
      
      if (namaDariMetadata != null && namaDariMetadata.isNotEmpty) {
        userName.value = namaDariMetadata;
      } else {
        userName.value = currentUser.email?.split('@')[0] ?? 'Saya';
      }
    } else {
      // 2. LOGIC KRITIS: UNTUK USER LAIN (Menggunakan tabel profiles)
      try {
        final profileData = await supabase
            .from('profiles')
            .select('name')
            .eq('id', itemUserId) // Cari user ID dari item yang dilihat
            .single(); // Harusnya hanya mengembalikan 1 baris
            
        // Jika data ditemukan dan nama tidak null:
        final String? profileName = profileData['name'] as String?;
        if (profileName != null && profileName.isNotEmpty) {
            userName.value = profileName;
        } else {
            userName.value = 'User Anonim (Nama Kosong)';
        }

      } catch (e) {
        // Jika query gagal (misalnya karena RLS memblokir atau ID tidak ditemukan)
        print('Gagal mengambil profil user lain: $e');
        userName.value = 'User Lain (Gagal Diambil)'; 
      }
    }
  }

  String formatDisplayDate(String dateString) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString; // Fallback jika error
    }
  }

}