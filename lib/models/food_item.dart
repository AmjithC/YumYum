class FoodItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String restaurantName;
  final int restaurantId;
  final String imageUrl;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.restaurantName,
    required this.restaurantId,
    required this.imageUrl,
  });

  factory FoodItem.fromJson(Map<String, dynamic> j) => FoodItem(
        id: j['itemID'] ?? 0,
        name: j['itemName'] ?? '',
        description: j['itemDescription'] ?? '',
        price: (j['itemPrice'] ?? 0).toDouble(),
        restaurantName: j['restaurantName'] ?? '',
        restaurantId: j['restaurantID'] ?? 0,
        imageUrl: j['imageUrl'] ?? '',
      );
}
