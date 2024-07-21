import 'package:flutter/material.dart';
import 'package:kickoff_kits/controllers/app_provider.dart';
import 'package:kickoff_kits/views/nav_bar.dart';
import 'package:kickoff_kits/views/order_view/order_details.dart';
import 'package:provider/provider.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NavBar()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Order History'),
      ),
      body: ordersProvider.orders.isEmpty
          ? const Center(child: Text('No orders found.'))
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (context, index) {
                final order = ordersProvider.orders[index];
                final itemCount = order.products.length;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          order.products.first.imageUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        'You placed an order on $itemCount items',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Total: ₦${order.totalPrice}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF067928),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
