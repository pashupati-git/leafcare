import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant_function.dart';
import 'all_products.dart';
import 'description_page.dart';
import 'search_page.dart'; // Import search page

class ShopHome extends StatefulWidget {
  const ShopHome({super.key});

  @override
  State<ShopHome> createState() => _HomePageState();
}

class _HomePageState extends State<ShopHome> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> cheapestProducts = [];
  bool isLoading = true;

  final brands = [
    {'icon': Icons.check, 'label': 'Nike'},
    {'icon': Icons.check, 'label': 'Adidas'},
    {'icon': Icons.check, 'label': 'Puma'},
    {'icon': Icons.check, 'label': 'NB'},
    {'icon': Icons.check, 'label': 'Converse'},
  ];

  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    loadCategories();
    loadCheapestProducts();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    setState(() {
      _currentTime = '$hour:$minute:$second $period';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> loadCategories() async {
    try {
      final result = await ConstantFunction.fetchCategories();
      setState(() {
        categories = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadCheapestProducts() async {
    try {
      final grouped = await ConstantFunction.fetchGroupedProductsByCategory();
      final cheapest = <Map<String, dynamic>>[];

      for (final products in grouped.values) {
        if (products.isNotEmpty) {
          products.sort((a, b) => (a['price'] as num).compareTo(b['price'] as num));
          cheapest.add(products.first);
        }
      }

      setState(() {
        cheapestProducts = cheapest;
      });
    } catch (e) {
      print('Error loading cheapest products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchPage()),
                        );
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Text("Search", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                    ? const Center(child: Text("No banners available"))
                    : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D592C),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item['slug'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const AllProducts()),
                                        );
                                      },
                                      child: const Text("Explore", style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 4,
                                child: Image.network(
                                  item['image'] ?? '',
                                  height: constraints.maxHeight * 0.7,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.sports_baseball, size: 24, color: Colors.black),
                        ),
                        const SizedBox(height: 6),
                        Text(brands[index]['label'] as String, style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today Sale!",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5228),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _currentTime,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: cheapestProducts.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cheapestProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final product = cheapestProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(product: product),
                          ),
                        );
                      },
                      child: _buildProductCard(
                        image: product['images']?.isNotEmpty == true ? product['images'][0] : '',
                        title: product['title'] ?? 'No Title',
                        subtitle: "\$${product['price']}",
                        category: product['category']?['name'] ?? 'Unknown',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String image,
    required String title,
    required String subtitle,
    required String category,
  }) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5228),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
