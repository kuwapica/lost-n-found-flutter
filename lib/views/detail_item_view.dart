import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lost_and_found/controllers/detail_item_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 

class DetailItemView extends GetView<DetailItemController> {
  const DetailItemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'NunitoSans',
            ),
            children: <TextSpan>[
              TextSpan(text: 'LOST N ', style: TextStyle(color: Colors.black)),
              TextSpan(text: 'FOUND', style: TextStyle(color: Colors.amber)),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.isTrue) {
          return const Center(child: CircularProgressIndicator(color: Colors.amber));
        }

        if (controller.itemDetail.value == null) {
          return const Center(child: Text('Detail barang tidak ditemukan.'));
        }

        final item = controller.itemDetail.value!;
        final String imageUrl = item['image_url'] as String? ?? '';
        final String name = item['name'] as String? ?? 'Nama Barang Tidak Diketahui';
        final String location = item['location'] as String? ?? 'Lokasi Tidak Diketahui';
        final String description = item['description'] as String? ?? 'Tidak ada deskripsi.';
        final String? currentUserId = Supabase.instance.client.auth.currentUser?.id;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama user (placeholder, Anda perlu mengambil data user dari Supabase)
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 20,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(width: 10),
                  Obx(() => Text( 
                    controller.userName.value,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              const SizedBox(height: 16),

              // Foto Barang
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.fitWidth,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber));
                        },
                        errorBuilder: (context, error, stackTrace) => const Text('foto error', style: TextStyle(color: Colors.red, fontSize: 12)),
                      ),
                    )
                  : const Text(
                      'foto barang',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
              ),
              const SizedBox(height: 16),

              // Detail Barang
              // Text(
              //   name,
              //   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              // const Divider(
              //   height: 1, // Tinggi total Divider
              //   thickness: 1.5, // Ketebalan garis
              //   color: Colors.grey, // Warna garis (bisa Colors.amber untuk aksen)
              // ),
              // const SizedBox(height: 16),
              // const Text(
              //   'Deskripsi :',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   description,
              //   style: const TextStyle(fontSize: 16),
              // ),
              // const SizedBox(height: 16),
              // Text(
              //   'Lokasi : $location',
              //   style: const TextStyle(fontSize: 14),
              // ),
              // const SizedBox(height: 4),
              // Text(
              //   'Waktu : ${controller.getTimeAgo(createdAt)}',
              //   style: const TextStyle(fontSize: 14),
              // ),
              // const SizedBox(height: 24),

              Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Divider(
                height: 1, 
                thickness: 1.5, 
                color: Colors.grey,
              ),
              const SizedBox(height: 16),

              // --- 1. BLOK INFORMASI LOKASI & WAKTU (Lebih Terstruktur) ---
              Card(
                elevation: 1,
                margin: EdgeInsets.zero, // Hapus margin agar rapi
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lokasi
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          RichText( // <--- GANTI DENGAN RICHTEXT
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: 'Lokasi : ',
                                  style: TextStyle(fontWeight: FontWeight.bold), // BOLD HANYA DI LABEL INI
                                ),
                                TextSpan(text: location),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Waktu
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          RichText( // <--- GANTI DENGAN RICHTEXT
                            text: TextSpan(
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: 'Tanggal : ',
                                  style: TextStyle(fontWeight: FontWeight.bold), // BOLD HANYA DI LABEL INI
                                ),
                                TextSpan(
                                  text: controller.formatDisplayDate(
                                    DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(
                                      DateFormat('yyyy-MM-dd').parse(item['date']))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // -----------------------------------------------------------------

              // --- 2. BLOK DESKRIPSI --
              const Text(
                'Deskripsi Barang', // Ganti label agar lebih jelas
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16, height: 1.5), // Tambah height untuk readability
              ),
              const SizedBox(height: 24),
              // -----------------------------------------------------------------
              
              _buildCommentSection(currentUserId),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCommentSection(String? currentUserId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Komentar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.commentController, // <--- BINDING CONTROLLER
          decoration: InputDecoration(
            hintText: 'Tambahkan komentar ...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send, color: Colors.amber),
              onPressed: controller.postComment, // <--- PANGGIL FUNGSI POST
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Daftar Komentar
        Obx(() {
          if (controller.isCommentsLoading.isTrue) {
            return const Center(child: CircularProgressIndicator(color: Colors.amber));
          }
          if (controller.comments.isEmpty) {
            return const Text(
              'Belum ada komentar.',
              style: TextStyle(color: Colors.grey),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Untuk scroll yang lancar di dalam SingleChildScrollView
            itemCount: controller.comments.length,
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              final String commentUserName = comment['profiles']['name'] as String? ?? 'User Tidak Dikenal';
              final String timeAgo = controller.getTimeAgo(comment['created_at']);
              final bool isMyComment = comment['user_id'] == currentUserId;
              
              // --- 1. ACTION: Quote (Long Press) ---
              return GestureDetector(
                // onLongPress: () {
                  // Logika Quote: Salin teks komentar ke input field
                  // final quoteText = '"> ${comment['content']}"\n';
                  // Asumsi controller memiliki TextEditingController bernama commentController
                  // controller.commentController.text = quoteText + controller.commentController.text;
                //   FocusScope.of(context).requestFocus(controller.commentFocusNode); // Fokus ke input
                // },

                // --- 2. ACTION: Swipe/Hapus (Dismissible) ---
                child: Dismissible(
                  key: ValueKey(comment['id']),
                  direction: isMyComment ? DismissDirection.endToStart : DismissDirection.none, // Hanya bisa di-swipe jika milik kita
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    // Panggil fungsi hapus dan konfirmasi dari Controller
                    return await controller.deleteComment(comment['id'] as String);
                  },

                  // --- Konten Komentar ---
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          // ignore: deprecated_member_use
                          backgroundColor: Colors.amber.withOpacity(0.5),
                          radius: 15,
                          child: Text(commentUserName[0], style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    commentUserName,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    timeAgo,
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(comment['content'] as String),
                            ],
                          ),
                        ),
                        if (isMyComment) // Tampilkan hanya jika komentar milik kita
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.grey, size: 18),
                            onPressed: () {
                              controller.deleteComment(comment['id'] as String); // Panggil hapus
                            },
                          ),
                      ],
                    ),
                  )
                )
              );
            },
          );
        }),
      ],
    );
  }
}