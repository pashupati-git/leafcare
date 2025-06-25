import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/constant_function.dart';
import 'description_page.dart';
import '../screens/home.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.black),
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => const Home()),
      //       );
      //     },
      //   ),
      //   title: const Text("All Products", style: TextStyle(color: Colors.black)),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: ConstantFunction.fetchGroupedProductsByCategory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            final groupedProducts = snapshot.data ?? {};

            if (groupedProducts.isEmpty) {
              return const Center(child: Text("No products available."));
            }

            return ListView.builder(
              padding: EdgeInsets.fromLTRB(
                w * 0.04,
                h * 0.02,
                w * 0.04,
                h * 0.04,
              ),
              itemCount: groupedProducts.keys.length,
              itemBuilder: (context, categoryIndex) {
                final categoryName = groupedProducts.keys.elementAt(categoryIndex);
                final products = groupedProducts[categoryName]!;

                return Padding(
                  padding: EdgeInsets.only(bottom: h * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName.toUpperCase(),
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: h * 0.015),

                      SizedBox(
                        height: h * 0.26,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          separatorBuilder: (_, __) => SizedBox(width: w * 0.04),
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final image = (product["images"] as List).isNotEmpty
                                ? product["images"][0]
                                : "https://placehold.co/600x400";

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DescriptionPage(product: product),
                                  ),
                                );
                              },
                              child: Container(
                                width: w * 0.45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        image,
                                        height: h * 0.16,
                                        width: w * 0.45,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.network(
                                            'https://thumbs.dreamstime.com/b/image-not-available-icon-vector-set-white-background-eps-330821927.jpg',
                                            height: h * 0.16,
                                            width: w * 0.45,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(w * 0.025),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              product["title"] ?? "No Title",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: w * 0.032,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              "\$${product["price"]}",
                                              style: GoogleFonts.poppins(
                                                fontSize: w * 0.04,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.deepOrange,
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
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
