// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:mazdoor_pk/notifications.dart';
import 'package:mazdoor_pk/productList.dart';
import 'package:mazdoor_pk/productsPosted.dart';
import 'package:mazdoor_pk/profile.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

// ignore: camel_case_types
class HomeProducts extends StatefulWidget {
  const HomeProducts({Key? key}) : super(key: key);

  @override
  State<HomeProducts> createState() => HomeProductsState();
}

// ignore: camel_case_types
class HomeProductsState extends State<HomeProducts> {
  @override
  Widget build(BuildContext context) {
    int _selected_index = 0;
    PageController _pageController = PageController();

    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            Center(child: ProductList()),
            Center(child: ProductsPosted()),
            Center(child: Notifications()),
            Center(child: Profile()),
          ],
        ),
        bottomNavigationBar: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: GNav(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: const Color.fromARGB(255, 80, 232, 176),
                gap: 8,
                tabBorderRadius: 33,
                color: Colors.black,
                iconSize: 23,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                activeColor: Colors.black,
                selectedIndex: _selected_index,
                onTabChange: (index) {
                  setState(() {
                    _selected_index = index;
                    _pageController.animateToPage(index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                  });
                },
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.box,
                    text: 'Products',
                  ),
                  GButton(
                    icon: LineIcons.bell,
                    text: 'Notifications',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
