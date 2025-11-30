import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/routes/app_routes.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Nama Menu Item
            _buildMenuItem(
              icon: Icons.person,
              title: 'Nama',
              subtitle: 'Ketuk untuk mengganti nama',
              onTap: () async {
                final result = await Get.toNamed(AppRoutes.editName);
                if (result == true) {
                  Get.back(result: true);
                }
              },
            ),
            const Divider(height: 1, color: Colors.grey),
            
            // Email Menu Item (non-clickable)
            _buildMenuItem(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'Email tidak bisa diubah',
              onTap: null,
            ),
            const Divider(height: 1, color: Colors.grey),
            
            // Password Menu Item
            _buildMenuItem(
              icon: Icons.lock,
              title: 'Password',
              subtitle: 'Ketuk untuk mengganti password',
              onTap: () async {
                final result = await Get.toNamed(AppRoutes.editPassword);
                if (result == true) {
                  Get.back(result: true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}