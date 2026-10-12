import 'package:flutter/material.dart';
import 'package:yum_quick/view/widgets/bottom_bar.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service"),
      ),
      body: const Center(
        child: Text("Service Page"),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}