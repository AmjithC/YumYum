import 'package:flutter/material.dart';
import 'package:yum_quick/view/widgets/bottom_bar.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      body: const Center(
        child: Text("Order Page"),
      ),
      bottomNavigationBar: const BottomNavBar(
        currentIndex: 3,
      ),
    );
  }
}