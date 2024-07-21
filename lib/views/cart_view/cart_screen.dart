import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kickoff_kits/controllers/app_provider.dart';
import 'package:kickoff_kits/views/appwidget.dart';
import 'package:kickoff_kits/views/cart_view/checkout.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    int totalItems =
        cartItems.values.fold(0, (sum, quantity) => sum + quantity);

    final NumberFormat currencyFormat = NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('Cart'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$totalItems Items',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.keys.length,
                    itemBuilder: (context, index) {
                      final product = cartItems.keys.elementAt(index);
                      final quantity = cartItems[product]!;

                      return Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Image.network(
                              product.imageUrl,
                              height: 120,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currencyFormat.format(product.price),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF067928),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'M',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.8),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              cartProvider
                                                  .decreaseQuantity(product);
                                            },
                                          ),
                                          Text('$quantity'),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              cartProvider
                                                  .increaseQuantity(product);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          cartProvider.removeItem(product);
                                        },
                                        child: SvgPicture.asset(
                                            'assets/svg/Trash.svg'),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Remove',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                OrderSummary(
                  totalItems: totalItems,
                  totalPrice: cartProvider.totalPrice,
                  onCheckout: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
                    );
                  },
                  btnText: 'Proceed to Checkout',
                ),
              ],
            ),
    );
  }
}
