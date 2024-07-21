import 'package:flutter/material.dart';
import 'package:kickoff_kits/model/product_model.dart';
import 'package:kickoff_kits/controllers/product_controller.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _allProducts = [];
  List<ProductModel> _moreOfWhatYouLike = [];
  List<ProductModel> _topSellers = [];

  bool _isLoading = true;
  bool _hasError = false;

  List<ProductModel> get allProducts => _allProducts;
  List<ProductModel> get moreOfWhatYouLike => _moreOfWhatYouLike;
  List<ProductModel> get topSellers => _topSellers;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  ProductProvider() {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      notifyListeners();

      final allProductsFuture = ProductController.getProducts();
      final moreOfWhatYouLikeFuture =
          ProductController.getProductByCategory('more of what you like');
      final topSellersFuture =
          ProductController.getProductByCategory('top sellers');

      final results = await Future.wait(
          [allProductsFuture, moreOfWhatYouLikeFuture, topSellersFuture]);

      _allProducts = results[0];
      _moreOfWhatYouLike = results[1];
      _topSellers = results[2];

      _isLoading = false;
      _hasError = false;
    } catch (e) {
      _isLoading = false;
      _hasError = true;
    } finally {
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    await fetchProducts();
  }
}
