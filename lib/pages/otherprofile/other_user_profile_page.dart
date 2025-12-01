import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/controllers/other_user_profile_controller.dart';
import 'package:lost_and_found/routes/app_routes.dart';

class OtherUserProfilePage extends GetView<OtherUserProfileController> {
  const OtherUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ),
        body: Column(
          children: [
            Obx(() {
              if (controller.isLoadingProfile.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: controller.userAvatarUrl.value.isNotEmpty
                        ? NetworkImage(controller.userAvatarUrl.value)
                        : null,
                    child: controller.userAvatarUrl.value.isEmpty
                        ? const Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.userName.value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (controller.userEmail.value.isNotEmpty)
                    Text(
                      controller.userEmail.value,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 20),
                ],
              );
            }),

            const TabBar(
              indicatorColor: Color(0xFFFCD303),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              tabs: [
                Tab(text: "Lost"),
                Tab(text: "Found"),
              ],
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoadingItems.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                return TabBarView(
                  children: [
                    _buildItemList(controller.userLostItems),
                    _buildItemList(controller.userFoundItems),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 50, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text(
              "Belum ada postingan",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItemCard(items[index]),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.detailItem, arguments: {'id': item['id']});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: item['image_url'] != null && item['image_url'] != ''
                      ? ClipRRect(
                          child: Image.network(
                            item['image_url'],
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFFCD303),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      'Error',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, color: Colors.grey),
                            Text(
                              'No Image',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Barang
                            Text(
                              item['title'] ?? item['name'] ?? 'Nama Barang',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Lokasi: ${item['location'] ?? '-'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          controller.getTimeAgo(item['created_at']),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
