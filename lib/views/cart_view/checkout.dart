import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kickoff_kits/controllers/local_database.dart';
import 'package:kickoff_kits/model/order_model.dart';
import 'package:kickoff_kits/views/appwidget.dart';
import 'package:kickoff_kits/views/nav_bar.dart';
import 'package:kickoff_kits/views/home_view/product_screen.dart';
import 'package:provider/provider.dart';
import 'package:kickoff_kits/controllers/app_provider.dart';
import 'package:kickoff_kits/model/product_model.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    int totalItems =
        cartItems.values.fold(0, (sum, quantity) => sum + quantity);

    void paymentSuccess(BuildContext context) async {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final ordersProvider =
          Provider.of<OrdersProvider>(context, listen: false);

      //OrderModel from cart data
      final order = OrderModel(
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        products: cartProvider.items.keys.toList(),
        totalPrice: cartProvider.totalPrice,
        orderDate: DateTime.now(),
        productQuantity: Map.from(cartProvider.items),
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/succesful.svg'),
                  const SizedBox(height: 30),
                  const Text(
                    'Payment Successful',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your order is being processed and you will receive a mail with details.',
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.800000011920929),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 0),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () async {
                      // Add order to history
                      await ordersProvider.addOrder(order);

                      // Clear the cart
                      cartProvider.clearCart();

                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => NavBar()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF067928),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Items',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Items List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cartItems.keys.length,
              itemBuilder: (context, index) {
                final product = cartItems.keys.elementAt(index);
                final quantity = cartItems[product]!;
                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₦${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF067928),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        'M',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'x$quantity',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Delivery Options
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Delivery Options',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: TabBar(
                      indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Delivery'),
                        Tab(text: 'Pickup'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 800,
                    child: TabBarView(
                      children: [
                        // Delivery Form
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CustomTextField(
                                label: 'First Name',
                                hintText: 'First Name',
                              ),
                              const SizedBox(height: 10),
                              const CustomTextField(
                                label: 'Last Name',
                                hintText: 'Last Name',
                              ),
                              const SizedBox(height: 10),
                              const CustomTextField(
                                label: 'Email',
                                hintText: 'Email Address',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 10),
                              CustomTextField(
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      SvgPicture.asset('assets/svg/help.svg'),
                                ),
                                label: 'Phone Number',
                                hintText: '+234',
                                keyboardType: TextInputType.phone,
                                prefixIcon:
                                    SvgPicture.asset('assets/svg/Dropdown.svg'),
                              ),
                              const SizedBox(height: 10),
                              const CustomTextField(
                                label: 'Address Line 1*',
                                hintText: 'Address Line 1*',
                              ),
                              const SizedBox(height: 10),
                              const CustomTextField(
                                label: 'Address Line 2',
                                hintText: 'Address Line 2',
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Country*',
                                      hintText: 'Country*',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'State*',
                                      hintText: 'State*',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Post Code',
                                      hintText: 'Enter Post Code',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'City',
                                      hintText: 'Enter City',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Pickup Form
                        const Center(child: Text('Pickup form goes here')),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Payment Options
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Payment Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.grey[200],
                    child: TabBar(
                      indicatorPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Card'),
                        Tab(text: 'Bank Transfer'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 350,
                    child: TabBarView(
                      children: [
                        // Card Payment Form
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const CustomTextField(
                                label: 'Name on Card*',
                                hintText: 'Name on Card*',
                              ),
                              CustomTextField(
                                label: 'Card number*',
                                prefixIcon: SvgPicture.asset(
                                    'assets/svg/master-card.svg'),
                                hintText: '1234 1234 1234 1234',
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'Expiry Date*',
                                      hintText: '00/00',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'CVV*',
                                      hintText: '000*',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Bank Transfer Form (if needed, can leave empty or add content)
                        const Center(
                            child: Text('Bank transfer details go here')),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            OrderSummary(
              totalItems: totalItems,
              totalPrice: cartProvider.totalPrice,
              onCheckout: () {
                paymentSuccess(context);
              },
              btnText: 'Make Payment',
            ),
          ],
        ),
      ),
    );
  }
}
