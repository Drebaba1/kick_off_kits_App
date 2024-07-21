import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kickoff_kits/controllers/app_provider.dart';
import 'package:kickoff_kits/controllers/product_provider.dart';
import 'package:kickoff_kits/model/product_model.dart';
import 'package:kickoff_kits/views/appwidget.dart';
import 'package:kickoff_kits/views/cart_view/cart_screen.dart';
import 'package:kickoff_kits/views/home_view/new_arrival.dart';
import 'package:kickoff_kits/views/order_view/order_history.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProductShowcaseScreen extends StatefulWidget {
  const ProductShowcaseScreen({super.key});

  @override
  State<ProductShowcaseScreen> createState() => _ProductShowcaseScreenState();
}

class _ProductShowcaseScreenState extends State<ProductShowcaseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: RefreshIndicator(
        onRefresh: productProvider.refreshProducts,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: productProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  color: Colors.blue.shade900,
                ),
              )
            : productProvider.hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.asset('assets/png/error.png'),
                        ),
                        const Text(
                          'Error connecting to server',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 5),
                        MaterialButton(
                          color: Colors.black,
                          onPressed: productProvider.refreshProducts,
                          child: const Text(
                            'Tap to refresh',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search for anything',
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  suffixIcon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.notifications_none_outlined),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.history_sharp),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const OrderHistory(),
                                  ),
                                );
                              },
                            ),
                            Stack(
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                      'assets/svg/cart_green.svg'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CartScreen(),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 5,
                                  right: 2,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 10,
                                    child: Text(
                                      '${cartProvider.itemCount}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/png/Hero Image Container.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionHeader('New Arrivals', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewArrivalScreen(
                              newArrivals: productProvider.allProducts,
                            ),
                          ),
                        );
                      }),
                      allProductList(
                          productProvider.allProducts, wishlistProvider),
                      _buildSectionHeader('Top Sellers', () {}),
                      allProductList(
                          productProvider.topSellers, wishlistProvider),
                      _buildSectionHeader('More of what you like', () {}),
                      moreProductList(productProvider.moreOfWhatYouLike),
                    ],
                  ),
      ),
    );
  }

  Widget allProductList(
      List<ProductModel> products, WishlistProvider wishlistProvider) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product: product);
        },
      ),
    );
  }
}

Widget _buildSectionHeader(String title, VoidCallback onSeeMore) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        TextButton(
          onPressed: onSeeMore,
          child: const Text(
            'See more',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF067928)),
          ),
        ),
      ],
    ),
  );
}

Widget moreProductList(List<ProductModel> products) {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2 / 3,
    ),
    itemCount: products.length,
    itemBuilder: (context, index) {
      final product = products[index];
      final formattedPrice =
          NumberFormat.currency(symbol: '₦', decimalDigits: 0)
              .format(product.price);
      final wishlistProvider = Provider.of<WishlistProvider>(context);

      return Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
                      Provider.of<CartProvider>(context, listen: false)
                          .toggleItem(product);

                      product.isAddedToCart = !product.isAddedToCart;

                      (context as Element).markNeedsBuild();
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
      );
    },
  );
}
