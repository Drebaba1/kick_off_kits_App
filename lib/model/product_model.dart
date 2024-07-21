const timbuImageUrl = 'https://api.timbu.cloud/images';

class ProductModel {
  ProductModel({
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.imageUrl,
    required this.categories,
    required this.price,
    required this.quantity,
    this.isAddedToCart = false,
    this.isInWishlist = false, // Add this field
  });

  String name;
  String description;
  List<Map<String, dynamic>> categories;
  bool isAvailable;
  String imageUrl;
  double quantity;
  double price;
  bool isAddedToCart;
  bool isInWishlist;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
      'categories': categories,
      'price': price,
      'quantity': quantity,
      'isAddedToCart': isAddedToCart,
      'isInWishlist': isInWishlist,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> data) {
    double price = 0;
    if (data['current_price'] != null &&
        data['current_price'] is List &&
        data['current_price'].isNotEmpty) {
      var priceData = data['current_price'][0];
      if (priceData['NGN'] != null && priceData['NGN'].isNotEmpty) {
        price = priceData['NGN'][0];
      }
    }

    return ProductModel(
      name: data['name'],
      description: data['description'],
      isAvailable: data['is_available'],
      categories: List<Map<String, dynamic>>.from(data['categories']),
      imageUrl: '$timbuImageUrl/${data['photos'][0]['url']}',
      price: price,
      quantity: data['available_quantity'] ?? 0,
    );
  }
}
