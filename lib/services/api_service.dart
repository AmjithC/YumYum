import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class ApiService {
  static const _base =
      'https://fakerestaurantapi.runasp.net/api/Restaurant/items';

  /// Get all items, or search by item name when [name] is given.
  Future<List<FoodItem>> getItems({String? name}) async {
    final q = name?.trim() ?? '';
    final uri = q.isEmpty
        ? Uri.parse(_base)
        : Uri.parse(_base).replace(queryParameters: {'ItemName': q});
    final res = await http.get(uri);
    if (res.statusCode == 404) return [];
    if (res.statusCode != 200) {
      throw Exception('Failed to load items (${res.statusCode})');
    }
    final data = jsonDecode(res.body);
    if (data is! List) return [];
    return data
        .map<FoodItem>((e) => FoodItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
