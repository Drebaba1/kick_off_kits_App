import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kickoff_kits/controllers/app_provider.dart';
import 'package:kickoff_kits/model/product_model.dart';
import 'package:provider/provider.dart';

class NewArrivalScreen extends StatefulWidget {
  final List<ProductModel> newArrivals;

  const NewArrivalScreen({super.key, required this.newArrivals});

  @override
  State<NewArrivalScreen> createState() => _NewArrivalScreenState();
}

class _NewArrivalScreenState extends State<NewArrivalScreen> {
  @override
  void initState() {
    super.initState();
  }

  void toggleCartStatus(ProductModel product) {
    setState(() {
      product.isAddedToCart = !product.isAddedToCart;
      if (product.isAddedToCart) {
        Provider.of<CartProvider>(context, listen: false).addItem(product);
      } else {
        Provider.of<CartProvider>(context, listen: false).removeItem(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Arrivals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2 / 3,
          ),
          itemCount: widget.newArrivals.length,
          itemBuilder: (context, index) {
            final product = widget.newArrivals[index];

            final formattedPrice =
                NumberFormat.currency(symbol: '₦', decimalDigits: 0)
                    .format(product.price);
            final wishlistProvider = Provider.of<WishlistProvider>(context);
            return Container(
              width: 160,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.fill,
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                        ),
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
                              if (wishlistProvider.isInWishlist(product)) {
                                wishlistProvider.removeItem(product);
                              } else {
                                wishlistProvider.addItem(product);
                              }
                            },
                            child: SvgPicture.asset(
                              wishlistProvider.isInWishlist(product)
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
                            toggleCartStatus(product);
                          },
                          child: SvgPicture.asset(
                            product.isAddedToCart
                                ? 'assets/svg/cart_green2.svg'
                                : 'assets/svg/shopping_cart.svg',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
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
            );
          },
        ),
      ),
    );
  }
}
