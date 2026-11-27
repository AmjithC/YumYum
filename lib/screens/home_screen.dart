import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../models/sample_foods.dart';
import '../services/api_service.dart';
import '../services/cart_provider.dart';
import '../theme.dart';
import '../widgets/food_image.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onCartTap;
  final ValueChanged<FoodItem> onToggleFavorite;
  final bool Function(FoodItem) isFavorite;

  const HomeScreen({
    super.key,
    required this.onCartTap,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<FoodItem>> _recommendations;

  @override
  void initState() {
    super.initState();
    _recommendations = ApiService().getItems();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;
    final name = FirebaseAuth.instance.currentUser?.displayName?.trim();
    final firstName = name == null || name.isEmpty
        ? FirebaseAuth.instance.currentUser?.email?.split('@').first ?? 'there'
        : name.split(RegExp(r'\s+')).first;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
              decoration: const BoxDecoration(
                color: AppColors.yellow,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/Capa_2.png', width: 34, height: 34),
                        const SizedBox(width: 8),
                        const Text(
                          'YumQuick',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Open your cart',
                          onPressed: widget.onCartTap,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white.withValues(alpha: .8),
                          ),
                          icon: Badge(
                            isLabelVisible: cartCount > 0,
                            label: Text('$cartCount'),
                            backgroundColor: AppColors.primary,
                            textColor: Colors.white,
                            child: const Icon(Icons.shopping_bag_outlined,
                                color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Good afternoon,',
                      style: TextStyle(color: AppColors.dark, fontSize: 13),
                    ),
                    Text(
                      firstName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'What would you like to eat today?',
                      style: TextStyle(color: AppColors.dark, fontSize: 13),
                    ),
                    const SizedBox(height: 18),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MenuScreen(
                            onCartTap: widget.onCartTap,
                            onToggleFavorite: widget.onToggleFavorite,
                            isFavorite: widget.isFavorite,
                          ),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: AppColors.primary),
                            SizedBox(width: 10),
                            Text(
                              'Search for your favourite food',
                              style: TextStyle(
                                  color: AppColors.grey, fontSize: 13),
                            ),
                            Spacer(),
                            Icon(Icons.tune, color: AppColors.dark, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            sliver: SliverToBoxAdapter(
              child: _PromotionBanner(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(
                      item: sampleFoods.first,
                      isFavorite: widget.isFavorite(sampleFoods.first),
                      onToggleFavorite: () =>
                          widget.onToggleFavorite(sampleFoods.first),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
            sliver: SliverToBoxAdapter(
              child: _SectionHeading(
                title: 'Categories',
                action: 'See all',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MenuScreen(
                      onCartTap: widget.onCartTap,
                      onToggleFavorite: widget.onToggleFavorite,
                      isFavorite: widget.isFavorite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: foodCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final category = foodCategories[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MenuScreen(
                          initialCategory: category.$1,
                          onCartTap: widget.onCartTap,
                          onToggleFavorite: widget.onToggleFavorite,
                          isFavorite: widget.isFavorite,
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: 68,
                      child: Column(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.all(14),
                            child: Image.asset(category.$2),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category.$1,
                            style: const TextStyle(
                              color: AppColors.dark,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _SectionHeading(
                title: 'Best sellers',
                action: 'See all',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MenuScreen(
                      onCartTap: widget.onCartTap,
                      onToggleFavorite: widget.onToggleFavorite,
                      isFavorite: widget.isFavorite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 218,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final item = sampleFoods[index];
                  return _BestSellerCard(
                    item: item,
                    isFavorite: widget.isFavorite(item),
                    onToggleFavorite: () => widget.onToggleFavorite(item),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(
              child: _SectionHeading(
                title: 'Recommended for you',
                action: 'See all',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MenuScreen(
                      onCartTap: widget.onCartTap,
                      onToggleFavorite: widget.onToggleFavorite,
                      isFavorite: widget.isFavorite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<FoodItem>>(
              future: _recommendations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(26),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 24),
                    child: Text(
                      'Recommendations are unavailable right now. Browse our best sellers above.',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  );
                }
                final remoteItems = snapshot.data ?? [];
                final items = remoteItems.isEmpty
                    ? sampleFoods.skip(4).toList()
                    : remoteItems.take(4).toList();
                return Column(
                  children: [
                    for (final item in items)
                      _RecommendedRow(
                        item: item,
                        isFavorite: widget.isFavorite(item),
                        onToggleFavorite: () => widget.onToggleFavorite(item),
                      ),
                  ],
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  final String initialCategory;
  final VoidCallback onCartTap;
  final ValueChanged<FoodItem> onToggleFavorite;
  final bool Function(FoodItem) isFavorite;

  const MenuScreen({
    super.key,
    this.initialCategory = 'All',
    required this.onCartTap,
    required this.onToggleFavorite,
    required this.isFavorite,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _api = ApiService();
  final _search = TextEditingController();
  Timer? _debounce;
  late Future<List<FoodItem>> _items;
  late String _category;

  static const _filters = [
    'All',
    'Meals',
    'Vegan',
    'Snacks',
    'Drinks',
    'Desserts'
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _items = _api.getItems();
  }

  void _searchItems(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _items = _api.getItems(name: query));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Explore menu'),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: widget.onCartTap,
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: TextField(
              controller: _search,
              onChanged: _searchItems,
              decoration: const InputDecoration(
                hintText: 'Search dishes or restaurants',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final selected = filter == _category;
                return ChoiceChip(
                  label: Text(filter),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : AppColors.dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => _category = filter),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<FoodItem>>(
              future: _items,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (snapshot.hasError) {
                  return _MenuMessage(
                    message: 'We could not load the menu.',
                    action: 'Try again',
                    onTap: () => setState(
                      () => _items = _api.getItems(name: _search.text),
                    ),
                  );
                }
                var foods = snapshot.data ?? [];
                if (foods.isEmpty) foods = sampleFoods;
                if (_category != 'All') {
                  final matching = foods
                      .where((item) =>
                          '${item.name} ${item.description} ${item.restaurantName}'
                              .toLowerCase()
                              .contains(_category.toLowerCase()))
                      .toList();
                  foods = matching.isEmpty
                      ? sampleFoods.where((item) {
                          switch (_category) {
                            case 'Meals':
                              return const {-1, -3, -4, -6}.contains(item.id);
                            case 'Vegan':
                              return item.id == -7;
                            case 'Snacks':
                              return const {-2, -7}.contains(item.id);
                            case 'Desserts':
                              return item.id == -5;
                            case 'Drinks':
                              return item.id == -8;
                            default:
                              return true;
                          }
                        }).toList()
                      : matching;
                }
                if (foods.isEmpty) {
                  return const _MenuMessage(
                      message: 'No dishes in this category yet.');
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: foods.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => _MenuFoodCard(
                    item: foods[index],
                    isFavorite: widget.isFavorite(foods[index]),
                    onToggleFavorite: () =>
                        widget.onToggleFavorite(foods[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PromotionBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _PromotionBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 136,
          child: Stack(
            children: [
              Positioned(
                right: -14,
                top: -4,
                bottom: -4,
                width: 158,
                child: ClipOval(
                  child:
                      FoodImage(sampleFoods.first.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 140, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .22),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'TODAY’S SPECIAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'A little joy\nin every bite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Discover your new favourite',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;
  const _SectionHeading({
    required this.title,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.dark,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(action, style: const TextStyle(fontSize: 11)),
        ),
      ],
    );
  }
}

class _BestSellerCard extends StatelessWidget {
  final FoodItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  const _BestSellerCard({
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        width: 154,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 118,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FoodImage(item.imageUrl),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _FavoriteButton(
                      selected: isFavorite,
                      onTap: onToggleFavorite,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: _RatingBadge(label: '4.${8 - item.id.abs() % 3}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          context.read<CartProvider>().add(item);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} added')),
                          );
                        },
                        child: const Icon(Icons.add_circle,
                            color: AppColors.primary, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailScreen(
          item: item,
          isFavorite: isFavorite,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }
}

class _RecommendedRow extends StatelessWidget {
  final FoodItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  const _RecommendedRow({
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailScreen(
              item: item,
              isFavorite: isFavorite,
              onToggleFavorite: onToggleFavorite,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FoodImage(item.imageUrl, width: 70, height: 70),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.dark)),
                    const SizedBox(height: 4),
                    Text(item.restaurantName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.grey, fontSize: 11)),
                    const SizedBox(height: 6),
                    Text('\$${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12)),
                  ],
                ),
              ),
              _FavoriteButton(
                selected: isFavorite,
                onTap: onToggleFavorite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuFoodCard extends StatelessWidget {
  final FoodItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  const _MenuFoodCard({
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DetailScreen(
            item: item,
            isFavorite: isFavorite,
            onToggleFavorite: onToggleFavorite,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: FoodImage(item.imageUrl, width: 86, height: 86),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.dark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(item.restaurantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: AppColors.grey, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text('\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                ],
              ),
            ),
            Column(
              children: [
                _FavoriteButton(
                  selected: isFavorite,
                  onTap: onToggleFavorite,
                ),
                IconButton(
                  onPressed: () => context.read<CartProvider>().add(item),
                  icon: const Icon(Icons.add_circle,
                      color: AppColors.primary, size: 24),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  const _FavoriteButton({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: selected ? 'Remove from favorites' : 'Add to favorites',
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: .92),
      ),
      icon: Icon(
        selected ? Icons.favorite : Icons.favorite_border,
        color: AppColors.primary,
        size: 19,
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final String label;
  const _RatingBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: AppColors.yellow, size: 12),
          const SizedBox(width: 2),
          Text(label,
              style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MenuMessage extends StatelessWidget {
  final String message;
  final String? action;
  final VoidCallback? onTap;
  const _MenuMessage({required this.message, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu,
                color: AppColors.primary, size: 42),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.dark)),
            if (action != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onTap, child: Text(action!)),
            ],
          ],
        ),
      ),
    );
  }
}
