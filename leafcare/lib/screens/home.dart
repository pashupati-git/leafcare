import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leafcare/components/bottom_nav_bar.dart';
import 'package:leafcare/hub/hub_home.dart';
import 'package:leafcare/ml/ml_home.dart';
import 'package:leafcare/screens/auth_page.dart';
import 'package:leafcare/shop/shop_home.dart';

import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Scaffold(
          bottomNavigationBar: BottomNavBar(
            onTap: (index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
              setState(() {
                currentIndex = index;
              });
            },
            SelectedItem: currentIndex,
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomePage(),
              MlHome(),
              HubHome(),
              ShopHome(),
              AuthPage(),
            ],
          ),
        );
      },
    );
  }
}
