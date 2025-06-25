// cart_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/home.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final user = FirebaseAuth.instance.currentUser;
  double totalPrice = 0.0;

  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 1) return;
    final cartDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .doc(productId);

    await cartDoc.update({'quantity': newQuantity});
  }

  Future<void> removeFromCart(String productId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('cart');

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: cartRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
        
            final cartItems = snapshot.data!.docs;
            totalPrice = 0.0;
        
            for (var item in cartItems) {
              final price = (item['price'] as num).toDouble();
              final quantity = item.data().toString().contains('quantity')
                  ? (item['quantity'] as num).toInt()
                  : 1;
              totalPrice += price * quantity;
            }
        
            if (cartItems.isEmpty) {
              return const Center(child: Text('Your cart is empty.'));
            }
        
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final productId = item.id;
                      final name = item['name'];
                      final imageUrl = (item['image'] ?? '').toString().trim();
                      final price = (item['price'] as num).toDouble();
                      final quantity = item.data().toString().contains('quantity')
                          ? (item['quantity'] as num).toInt()
                          : 1;
                      final size = item['size'] ?? '';
                      final colorHex = item['color'] ?? '#FF000000';
                      final itemTotal = price * quantity;
        
                      final validImageUrl = (imageUrl.isNotEmpty &&
                          Uri.tryParse(imageUrl)?.hasAbsolutePath == true)
                          ? imageUrl
                          : 'https://via.placeholder.com/60';
        
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: Image.network(
                            validImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                'https://via.placeholder.com/60',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          title: Text(name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("\u20B9${itemTotal.toStringAsFixed(2)}"),
                              Text("Size: $size"),
                              Row(
                                children: [
                                  const Text("Color: "),
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: _hexToColor(colorHex),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      updateQuantity(productId, quantity - 1);
                                    },
                                  ),
                                  Text(quantity.toString(),
                                      style: const TextStyle(fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      updateQuantity(productId, quantity + 1);
                                    },
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () {
                                      removeFromCart(productId);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: \u20B9${totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement checkout functionality
                        },
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}