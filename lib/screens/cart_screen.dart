import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import '../theme.dart';
import '../widgets/food_image.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _busy = false;

  Future<void> _checkout(CartProvider cart) async {
    setState(() => _busy = true);
    try {
      await cart.checkout();
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Order placed 🎉'),
          content: const Text('Your food is on its way!'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'))
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Order failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final lines = cart.lines;
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My cart')),
      body: lines.isEmpty
          ? const _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: lines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) {
                      final l = lines[i];
                      return Dismissible(
                        key: ValueKey(l.item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => cart.remove(l.item),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18)),
                          child: Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: FoodImage(l.item.imageUrl,
                                  height: 72, width: 72),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l.item.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(l.item.restaurantName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12, color: AppColors.grey)),
                                  const SizedBox(height: 6),
                                  Text(
                                      '\$${(l.item.price * l.qty).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                            Row(children: [
                              _QtyBtn(
                                  Icons.remove, () => cart.decrement(l.item)),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('${l.qty}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                              _QtyBtn(Icons.add, () => cart.add(l.item)),
                            ]),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total',
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.grey)),
                          Text('\$${cart.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.dark)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: _busy ? null : () => _checkout(cart),
                        child: _busy
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Text('Place Order'),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn(this.icon, this.onTap);
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: AppColors.paleYellow,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 16, color: AppColors.dark),
        ),
      );
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: AppColors.paleYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  color: AppColors.primary, size: 42),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add something delicious and it will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
