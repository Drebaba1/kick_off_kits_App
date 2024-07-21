import 'package:kickoff_kits/model/product_model.dart';

class OrderModel {
  final String orderId;
  final List<ProductModel> products;
  final double totalPrice;
  final DateTime orderDate;
  // int itemCount;
  final Map<ProductModel, int> productQuantity;

  OrderModel(
      {required this.orderId,
      required this.products,
      required this.totalPrice,
      required this.orderDate,
      required this.productQuantity});

  // OrderModel to Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'products': products.map((p) => p.toMap()).toList(),
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  //  Map to OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'],
      products: List<ProductModel>.from(map['products']
          .map((p) => ProductModel.fromMap(Map<String, dynamic>.from(p)))),
      totalPrice: map['totalPrice'],
      orderDate: DateTime.parse(map['orderDate']),
      productQuantity: map['productQuantity'],
    );
  }
}
