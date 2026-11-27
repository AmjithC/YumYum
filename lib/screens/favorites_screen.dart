import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../services/cart_provider.dart';
import '../theme.dart';
import '../widgets/food_image.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<FoodItem> items;
  final ValueChanged<FoodItem> onRemove;

  const FavoritesScreen({
    super.key,
    required this.items,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My favorites')),
      body: items.isEmpty
          ? const _FavoritesEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: FoodImage(item.imageUrl, width: 82, height: 82),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                item: item,
                                isFavorite: true,
                                onToggleFavorite: () => onRemove(item),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.dark,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.restaurantName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            tooltip: 'Remove from favorites',
                            onPressed: () => onRemove(item),
                            icon: const Icon(Icons.favorite,
                                color: AppColors.primary, size: 20),
                          ),
                          IconButton(
                            tooltip: 'Add to cart',
                            onPressed: () =>
                                context.read<CartProvider>().add(item),
                            icon: const Icon(Icons.add_circle,
                                color: AppColors.primary, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

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
              child: const Icon(Icons.favorite_border,
                  color: AppColors.primary, size: 42),
            ),
            const SizedBox(height: 16),
            const Text(
              'No favorites yet',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap the heart on a dish to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
