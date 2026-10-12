import 'package:flutter/material.dart';
import 'package:yum_quick/view/widgets/bottom_bar.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text("Profile Page"),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 4,
      ),
    );
  }
}