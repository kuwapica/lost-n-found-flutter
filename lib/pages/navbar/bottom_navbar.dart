import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_and_found/controllers/bottomnav_controller.dart';
import 'package:lost_and_found/pages/post/post_page.dart';
import 'package:lost_and_found/pages/profile/profile_page.dart';

class BottomNavbar extends StatelessWidget {
  BottomNavbar({super.key});

  final BottomnavController controller = Get.put(BottomnavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            PostPage(), // Index 0 ganti page beranda
            PostPage(), // Index 1
            ProfilePage(), // Index 2 udah diganti page profile yaw
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          ),
          child: BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,

            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: const Color(0xFFFFD700),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.post_add, size: 30),
                label: 'Post',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
