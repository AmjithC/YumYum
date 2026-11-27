import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../theme.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final Map<int, FoodItem> _favorites = {};

  void _toggleFavorite(FoodItem item) {
    setState(() {
      if (_favorites.containsKey(item.id)) {
        _favorites.remove(item.id);
      } else {
        _favorites[item.id] = item;
      }
    });
  }

  bool _isFavorite(FoodItem item) => _favorites.containsKey(item.id);

  void _openCart() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onCartTap: _openCart,
            onToggleFavorite: _toggleFavorite,
            isFavorite: _isFavorite,
          ),
          MenuScreen(
            onCartTap: _openCart,
            onToggleFavorite: _toggleFavorite,
            isFavorite: _isFavorite,
          ),
          FavoritesScreen(
            items: _favorites.values.toList(),
            onRemove: _toggleFavorite,
          ),
          const OrdersScreen(),
          ProfileScreen(
            isActive: _index == 4,
            onBack: () => setState(() => _index = 0),
            onSignOut: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: AppColors.primary,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 54,
            child: Row(
              children: [
                _NavigationItem(
                  label: 'Home',
                  icon: _index == 0 ? Icons.home : Icons.home_outlined,
                  selected: _index == 0,
                  onTap: () => setState(() => _index = 0),
                ),
                _NavigationItem(
                  label: 'Menu',
                  icon: Icons.restaurant_menu,
                  selected: _index == 1,
                  onTap: () => setState(() => _index = 1),
                ),
                _NavigationItem(
                  label: 'Favorites',
                  icon: _index == 2 ? Icons.favorite : Icons.favorite_border,
                  selected: _index == 2,
                  badgeCount: _favorites.length,
                  onTap: () => setState(() => _index = 2),
                ),
                _NavigationItem(
                  label: 'Orders',
                  icon: Icons.receipt_long,
                  selected: _index == 3,
                  onTap: () => setState(() => _index = 3),
                ),
                _NavigationItem(
                  label: 'Profile',
                  icon: _index == 4 ? Icons.person : Icons.person_outline,
                  selected: _index == 4,
                  onTap: () => setState(() => _index = 4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        tooltip: label,
        onPressed: onTap,
        icon: Badge(
          isLabelVisible: badgeCount > 0,
          label: Text('$badgeCount'),
          backgroundColor: AppColors.yellow,
          textColor: AppColors.dark,
          child: Icon(icon, color: Colors.white, size: selected ? 25 : 23),
        ),
      ),
    );
  }
}
