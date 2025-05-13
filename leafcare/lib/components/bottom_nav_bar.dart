import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomNavBar extends StatefulWidget {
  final int SelectedItem;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.onTap, required this.SelectedItem});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;
    final isLoggedIn = user != null;

    String getUserEmailPrefix() {
      if (user != null && user.email != null && user.email!.isNotEmpty) {
        // Return the part before "@" sign in uppercase
        return user.email!.split('@')[0].toUpperCase();
      }
      return '';
    }

    // Logout confirmation dialog
    void _showLogoutDialog() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Do you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes"),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await FirebaseAuth.instance.signOut();
        setState(() {}); // Refresh UI to show sign-out state
        widget.onTap(0); // Optional: redirect to Home or sign-in page
      }
    }

    return Container(
      color: Colors.grey[100],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .015, vertical: h * .01),
        child: GNav(
          gap: 10,
          tabBorderRadius: 100,
          backgroundColor: Colors.grey[100]!,
          activeColor: Colors.white,
          color: Colors.blue[600],
          tabBackgroundGradient: LinearGradient(
            colors: [
              Colors.blue[400]!,
              Colors.blueAccent.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          iconSize: 30,
          textSize: 18,
          padding: EdgeInsets.symmetric(horizontal: w * .01, vertical: h * .01),
          tabs: [
            const GButton(icon: CupertinoIcons.home, text: 'Home'),
            const GButton(icon: CupertinoIcons.heart_circle, text: 'Cure'),
            const GButton(icon: CupertinoIcons.chat_bubble, text: 'Hub'),
            const GButton(icon: Icons.shop_2, text: 'Shop'),

            GButton(
              icon: CupertinoIcons.person,
              text: isLoggedIn ? getUserEmailPrefix() : 'Login',
              onPressed: () {
                if (isLoggedIn) {
                  // Show logout confirmation dialog
                  _showLogoutDialog();
                } else {
                  widget.onTap(0); // Navigate to login page if not logged in
                }
              },
            ),
          ],
          onTabChange: widget.onTap,
          selectedIndex: widget.SelectedItem,
        ),
      ),
    );
  }
}
