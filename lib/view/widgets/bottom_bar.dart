import 'package:flutter/material.dart';
import 'package:yum_quick/service/Service_Navbar.dart';
import 'package:yum_quick/view/faviorit/favriot.dart';
import 'package:yum_quick/view/homepage/home_page.dart';
import 'package:yum_quick/view/oder/oder_page.dart';


import 'package:yum_quick/view/profile/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({
    super.key,
    this.currentIndex = 0,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int selectedIndex;

  final List<Widget> pages = const [
    Homescreen(),
    ServicePage(),
    FavoritePage(),
    OrderPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.currentIndex;
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => pages[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          navIcon(Icons.home_outlined, 0),
          navIcon(Icons.room_service_outlined, 1),
          navIcon(Icons.favorite_border, 2),
          navIcon(Icons.receipt_long_outlined, 3),
          navIcon(Icons.headset_mic_outlined, 4),
        ],
      ),
    );
  }

  Widget navIcon(IconData icon, int index) {
    return IconButton(
      onPressed: () {
        onItemTapped(index);
      },
      icon: Icon(
        icon,
        color: selectedIndex == index
            ? Colors.white
            : Colors.white54,
        size: 32,
      ),
    );
  }
}