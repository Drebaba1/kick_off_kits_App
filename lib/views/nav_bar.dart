import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kickoff_kits/views/cart_view/cart_screen.dart';
import 'package:kickoff_kits/views/order_view/order_history.dart';
import 'package:kickoff_kits/views/home_view/product_screen.dart';
import 'package:kickoff_kits/views/wishlist/wishlist.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ProductShowcaseScreen(),
    WishlistScreen(),
    CartScreen(),
    const Center(
        child: Text('Coming Soon',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/store.svg'),
            activeIcon: SvgPicture.asset('assets/svg/store_green.svg'),
            label: 'Store',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(
              Icons.favorite,
              color: Color(0xFF067928),
            ),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/order.svg'),
            activeIcon: SvgPicture.asset('assets/svg/order_green.svg'),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/user.svg'),
            activeIcon: SvgPicture.asset('assets/svg/user_green.svg'),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF067928),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        unselectedFontSize: 10,
        showUnselectedLabels: false,
      ),
    );
  }
}
