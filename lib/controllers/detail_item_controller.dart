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
  final commentFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    // Ambil ID item dari argumen GetX
    final String itemId = Get.arguments['id']; 
    fetchItemDetail(itemId);
    fetchComments(itemId);
  }

  @override
  void onClose() {
    commentController.dispose();
    commentFocusNode.dispose(); 
    super.onClose();
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
                   // ignore: deprecated_member_use
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
        // ignore: avoid_print
        print('Gagal mengambil profil user lain: $e');
        userName.value = 'User Lain (Gagal Diambil)'; 
      }
    }
  }

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

  String formatDisplayDate(String dateString) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateString);
      return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return dateString; // Fallback jika error
    }
  }

  // --- Fungsi mengambil Komentar ---
  Future<void> fetchComments(String itemId) async {
    try {
      isCommentsLoading(true);
      // Join untuk mengambil komentar DAN nama user yang berkomentar
      final data = await supabase
          .from('comments')
          .select('*, profiles(name)') // Ambil semua komentar dan nama user
          .eq('item_id', itemId)
          .order('created_at', ascending: false);

      comments.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat komentar: $e');
    } finally {
      isCommentsLoading(false);
    }
  }

  Future<void> postComment() async {
    final String commentText = commentController.text.trim();
    if (commentText.isEmpty) return;

    final String itemId = Get.arguments['id'];
    // Anda harus mendapatkan user ID yang sedang login (dari AuthController)
    final String? currentUserId = supabase.auth.currentUser?.id;

    if (currentUserId == null) {
      Get.snackbar('Error', 'Anda harus login untuk berkomentar.');
      return;
    }

    try {
      await supabase.from('comments').insert({
        'item_id': itemId,
        'user_id': currentUserId,
        'content': commentText,
      });

      commentController.clear();
      // Refresh daftar komentar
      fetchComments(itemId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim komentar: $e');
    }
  }

  Future<bool?> deleteComment(String commentId) async {
    final currentUserId = supabase.auth.currentUser?.id;
    final String itemId = Get.arguments['id']; // Ambil ID item untuk refresh

    if (currentUserId == null) {
      Get.snackbar('Error', 'Anda harus login untuk menghapus komentar.');
      return Future.value(false);
    }

    // 1. Tampilkan dialog konfirmasi
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Komentar'),
        content: const Text('Apakah Anda yakin ingin menghapus komentar ini secara permanen?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Batal')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        // 2. Jalankan query hapus di Supabase
        await supabase
            .from('comments')
            .delete()
            .eq('id', commentId)
            .eq('user_id', currentUserId); // Filter tambahan untuk keamanan (hanya pemilik yang bisa hapus)

        // 3. Refresh daftar komentar setelah penghapusan
        fetchComments(itemId);
        Get.snackbar('Sukses', 'Komentar berhasil dihapus.', snackPosition: SnackPosition.BOTTOM);

        return true;

      } catch (e) {
        Get.snackbar('Error', 'Gagal menghapus komentar: $e', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    }

    return false;
  }
}