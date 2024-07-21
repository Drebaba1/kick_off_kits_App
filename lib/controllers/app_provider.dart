import 'package:flutter/foundation.dart';
import 'package:kickoff_kits/controllers/local_database.dart';
import 'package:kickoff_kits/model/order_model.dart';
import 'package:kickoff_kits/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvider with ChangeNotifier {
  Map<ProductModel, int> _items = {};

  Map<ProductModel, int> get items => _items;

  int get itemCount => _items.values.fold(0, (sum, quantity) => sum + quantity);

  // double get totalPrice => _items.entries
  //     .fold(0, (sum, entry) => sum + entry.key.price * entry.value);
  double get totalPrice {
    return _items.entries
        .map((entry) => entry.key.price * entry.value)
        .fold(0.0, (prev, amount) => prev + amount);
  }

  bool isInCart(ProductModel product) {
    return _items.containsKey(product);
  }

  void addItem(ProductModel product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
    notifyListeners();
  }

  void removeItem(ProductModel product) {
    _items.remove(product);
    notifyListeners();
    _saveCartToPrefs();
  }

  void increaseQuantity(ProductModel product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(ProductModel product) {
    if (_items.containsKey(product) && _items[product]! > 1) {
      _items[product] = _items[product]! - 1;
      notifyListeners();
    } else {
      removeItem(product);
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCartToPrefs();
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData =
        _items.map((key, value) => MapEntry(key.toMap().toString(), value));
    await prefs.setString('cart', json.encode(cartData));
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('cart')) {
      final cartData =
          json.decode(prefs.getString('cart')!) as Map<String, dynamic>;
      _items = cartData.map((key, value) =>
          MapEntry(ProductModel.fromMap(json.decode(key)), value));
      notifyListeners();
    }
  }

  void toggleItem(ProductModel product) {
    if (_items.containsKey(product)) {
      removeItem(product);
    } else {
      addItem(product);
    }
  }
}

class WishlistProvider with ChangeNotifier {
  final List<ProductModel> wishlist = [];

  List<ProductModel> get wishlistItems => wishlist;

  bool isInWishlist(ProductModel product) {
    return wishlist.contains(product);
  }

  void addItem(ProductModel product) {
    if (!wishlist.contains(product)) {
      wishlist.add(product);
      notifyListeners();
    }
  }

  void removeItem(ProductModel product) {
    wishlist.remove(product);
    notifyListeners();
  }
}

class OrdersProvider with ChangeNotifier {
  List<OrderModel> _orders = [];
  final PreferencesService _prefsService = PreferencesService();

  List<OrderModel> get orders => _orders;

  OrdersProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      _orders = await _prefsService.getOrders();
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error loading orders: $e");
    }
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      _orders.add(order);
      await _prefsService.setOrders(_orders);
      notifyListeners();
    } catch (e) {
      // Handle error
      print("Error adding order: $e");
    }
  }
}
