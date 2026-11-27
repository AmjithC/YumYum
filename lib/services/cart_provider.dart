import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/food_item.dart';

class CartLine {
  final FoodItem item;
  int qty;
  CartLine(this.item, this.qty);
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList();
  int get count => _lines.values.fold(0, (s, l) => s + l.qty);
  double get total =>
      _lines.values.fold(0.0, (s, l) => s + l.item.price * l.qty);

  void add(FoodItem item, {int qty = 1}) {
    final l = _lines[item.id];
    if (l == null) {
      _lines[item.id] = CartLine(item, qty);
    } else {
      l.qty += qty;
    }
    notifyListeners();
  }

  void decrement(FoodItem item) {
    final l = _lines[item.id];
    if (l == null) return;
    l.qty--;
    if (l.qty <= 0) _lines.remove(item.id);
    notifyListeners();
  }

  void remove(FoodItem item) {
    _lines.remove(item.id);
    notifyListeners();
  }

  /// Saves the order to Firestore (collection: orders) and clears the cart.
  Future<void> checkout() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('orders').add({
      'uid': user?.uid,
      'email': user?.email,
      'total': total,
      'status': 'Active',
      'createdAt': FieldValue.serverTimestamp(),
      'items': _lines.values
          .map((l) => {
                'itemId': l.item.id,
                'name': l.item.name,
                'restaurant': l.item.restaurantName,
                'price': l.item.price,
                'qty': l.qty,
              })
          .toList(),
    });
    _lines.clear();
    notifyListeners();
  }
}
