import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kickoff_kits/controllers/app_provider.dart';

import 'package:kickoff_kits/model/product_model.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final isInWishlist = wishlistProvider.isInWishlist(product);
    final isAddedToCart = cartProvider.isInCart(product);
    final formattedPrice = NumberFormat.currency(symbol: '₦', decimalDigits: 0)
        .format(product.price);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (isInWishlist) {
                          wishlistProvider.removeItem(product);
                        } else {
                          wishlistProvider.addItem(product);
                        }
                      },
                      child: SvgPicture.asset(
                        isInWishlist
                            ? 'assets/svg/heart_green.svg'
                            : 'assets/svg/Heart.svg',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      if (isAddedToCart) {
                        cartProvider.removeItem(product);
                      } else {
                        cartProvider.addItem(product);
                      }
                    },
                    child: SvgPicture.asset(
                      isAddedToCart
                          ? 'assets/svg/cart_green2.svg'
                          : 'assets/svg/shopping_cart.svg',
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedPrice,
                    style: const TextStyle(
                      color: Color(0xFF067928),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  const Row(children: [
                    Text(
                      '5',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label*',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.4),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFCFD4DC)),
              borderRadius: BorderRadius.circular(4),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Color(0xFFCFD4DC)),
              borderRadius: BorderRadius.circular(4),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: suffixIcon,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class OrderSummary extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final VoidCallback onCheckout;
  final String btnText;

  const OrderSummary({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.onCheckout,
    required this.btnText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '$totalItems',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '₦5,000',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '₦3,500',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Do you have a coupon code?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: TextField(
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'Enter coupon code',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      // width: 68,
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFF067928)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Color(0xFF067928),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sub Total',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '₦${totalPrice + 5000 + 3500}',
                    style: const TextStyle(
                      color: Color(0xFF067928),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onCheckout,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF067928),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Center(
                    child: Text(
                      btnText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
