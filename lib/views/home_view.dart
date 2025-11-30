import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/controllers/home_controller.dart';
import 'package:lost_and_found/routes/app_routes.dart'; // Ganti dengan path controller Anda

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan DefaultTabController untuk mengelola Tab Lost dan Found
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // --- Judul App ---
          title: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'NunitoSans', // Menggunakan font dari ThemeData
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'LOST N ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: 'FOUND',
                  style: TextStyle(color: Colors.amber), // Warna kuning
                ),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,

          // --- TabBar (Lost dan Found) ---
          bottom: TabBar(
            onTap: (index) {
              controller.currentTabIndex.value = index;
            },
            indicatorColor: Colors.amber,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            tabs: const [
              Tab(text: 'Lost'),
              Tab(text: 'Found'),
            ],
          ),
        ),

        // --- Isi Tab: Daftar Barang ---
        body: TabBarView(
          children: [
            // Konten untuk Tab 'Lost'
            _buildLostList(),
            // Konten untuk Tab 'Found'
            _buildFoundList(),
          ],
        ),

      ),
    );
  }

  // --- Widget untuk Daftar Barang Hilang (Tab 'Lost') ---
  Widget _buildLostList() {
    return Obx(() {
      // Menampilkan loading state
      if (controller.isLoadingLost.isTrue) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        );
      }
      
      final items = controller.lostItems;

      // Menampilkan empty state
      if (items.isEmpty) {
        return const Center(
            child: Text('Tidak ada barang hilang yang terdaftar.'));
      }

      // Menampilkan data
      return ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(
            context, 
            item, 
            locationKey: 'location', // Ganti dengan nama kolom di Supabase
            locationLabel: 'Lokasi Terakhir', 
            timeAgo: controller.getTimeAgo(item['created_at']),
          );
        },
      );
    });
  }

  // --- Widget untuk Daftar Barang Ditemukan (Tab 'Found') ---
  Widget _buildFoundList() {
    return Obx(() {
      // Menampilkan loading state
      if (controller.isLoadingFound.isTrue) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.amber),
        );
      }
      
      final items = controller.foundItems;

      // Menampilkan empty state
      if (items.isEmpty) {
        return const Center(
            child: Text('Tidak ada barang ditemukan yang terdaftar.'));
      }

      // Menampilkan data
      return ListView.builder(
        itemCount: items.length,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildItemCard(
            context, 
            item, 
            locationKey: 'location', // Ganti dengan nama kolom di Supabase
            locationLabel: 'Lokasi Ditemukan', 
            timeAgo: controller.getTimeAgo(item['created_at']),
          );
        },
      );
    });
  }

  // --- Widget Card Item (Dinamis untuk Lost/Found) ---
  Widget _buildItemCard(BuildContext context, Map<String, dynamic> item, {
    required String locationKey, 
    required String locationLabel, 
    required String timeAgo,
  }) {

    return GestureDetector( // <--- BUNGKUS DENGAN GestureDetector
    onTap: () {
      // Navigasi ke halaman detail dengan mengirimkan ID item
      Get.toNamed(AppRoutes.detailItem, arguments: {'id': item['id']});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kotak Foto Barang
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  // Logika menampilkan gambar dari 'image_url' atau placeholder
                  child: item['image_url'] != null && item['image_url'] != ''
                      ? Image.network(
                          item['image_url']!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber));
                          },
                          errorBuilder: (context, error, stackTrace) => const Text('foto error', style: TextStyle(color: Colors.red, fontSize: 12)),
                        )
                      : const Text(
                          'foto barang',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                ),
                const SizedBox(width: 16),
                
                // Detail Barang
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         item['name'] as String? ?? 'Nama Barang',
                //         style: const TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black,
                //         ),
                //         maxLines: 2,
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //       const SizedBox(height: 4),
                //       Text(
                //         '$locationLabel: ${item[locationKey] as String? ?? 'xxx'}',
                //         style: const TextStyle(
                //           fontSize: 14,
                //           color: Colors.black87,
                //         ),
                //       ),
                //       Text(
                //         timeAgo,
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Colors.grey[600],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                // Detail Barang
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Ubah mainAxisAlignment menjadi spaceBetween untuk mendorong waktu ke bawah
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      // --- BLOK ATAS: Nama Barang ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'] as String? ?? 'Nama Barang',
                            style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8), // Sedikit jarak lebih lebar
                          
                          // Lokasi dengan Ikon
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, color: Colors.grey, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '$locationLabel: ${item[locationKey] as String? ?? 'xxx'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      // --- BLOK BAWAH: Waktu (didorong ke bawah oleh mainAxisAlignment: spaceBetween) ---
                      Text(
                        timeAgo,
                        style: TextStyle(
                          fontSize: 12, // Dibuat sedikit lebih kecil
                          color: Colors.grey[600], // Highlight warna kuning
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ); 
  } 
}