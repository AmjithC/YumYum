import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../services/cart_provider.dart';
import '../theme.dart';
import '../widgets/food_image.dart';

class DetailScreen extends StatefulWidget {
  final FoodItem item;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const DetailScreen({
    super.key,
    required this.item,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _quantity = 1;
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Food details'),
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
            onPressed: widget.onToggleFavorite == null
                ? null
                : () {
                    widget.onToggleFavorite!();
                    setState(() => _isFavorite = !_isFavorite);
                  },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 260,
                    child: FoodImage(item.imageUrl),
                  ),
                  Positioned(
                    left: 14,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: AppColors.yellow, size: 15),
                          SizedBox(width: 4),
                          Text(
                            '4.8  (120+ reviews)',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: AppColors.dark,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.storefront,
                    color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.restaurantName,
                    style: const TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Icon(Icons.schedule, color: AppColors.grey, size: 15),
                const SizedBox(width: 4),
                const Text(
                  '20-30 min',
                  style: TextStyle(color: AppColors.grey, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              item.description.isEmpty
                  ? 'Freshly prepared with carefully selected ingredients.'
                  : item.description,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.paleYellow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() {
                        if (_quantity > 1) _quantity--;
                      }),
                      icon: const Icon(Icons.remove,
                          color: AppColors.primary, size: 18),
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add,
                          color: AppColors.primary, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartProvider>().add(item, qty: _quantity);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item.name} added to cart')),
                    );
                  },
                  child: Text(
                    'Add to cart  ·  \$${(item.price * _quantity).toStringAsFixed(2)}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
