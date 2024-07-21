import 'dart:convert';

import 'package:kickoff_kits/model/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _ordersKey = 'orders';

  // Get Orders from SharedPreferences
  Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_ordersKey) ?? '[]';
    final List<dynamic> ordersList = jsonDecode(ordersJson);
    return ordersList
        .map((item) => OrderModel.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  // Save Orders to SharedPreferences
  Future<void> setOrders(List<OrderModel> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(orders.map((item) => item.toMap()).toList());
    await prefs.setString(_ordersKey, ordersJson);
  }
}
