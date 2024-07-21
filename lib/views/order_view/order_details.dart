import 'package:flutter/material.dart';
import 'package:kickoff_kits/model/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.orderId}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Order Date: ${order.orderDate.toLocal()}'),
            const SizedBox(height: 10),
            Text('Total Price: ₦${order.totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Products:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: order.products.length,
                itemBuilder: (context, index) {
                  final product = order.products[index];
                  // final product = order.productQuantities.keys.elementAt(index);
                  final quantity = order.productQuantity[product]!;

                  return ListTile(
                    leading: Image.network(product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text(
                        'Price: ₦${product.price.toStringAsFixed(2)} x $quantity'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
