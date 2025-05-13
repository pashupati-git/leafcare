import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ShopHome extends StatelessWidget {
  const ShopHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> carouselImages = [
      'assets/images/banner1.jpg',
      'assets/images/banner2.jpg',
      'assets/images/banner3.jpg',
    ];

    final List<Map<String, String>> medicines = [
      {"name": "Fungal Cure", "image": "assets/images/medicine1.png"},
      {"name": "Insect Killer", "image": "assets/images/medicine2.png"},
    ];

    final List<Map<String, String>> tools = [
      {"name": "Hand Rake", "image": "assets/images/tool1.png"},
      {"name": "Water Sprayer", "image": "assets/images/tool2.png"},
    ];

    final List<Map<String, String>> agriTools = [
      {"name": "Soil Tester", "image": "assets/images/agri1.png"},
      {"name": "Fertilizer Kit", "image": "assets/images/agri2.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenShop'),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      backgroundColor: Colors.green[100],

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Enhanced Carousel Slider
              CarouselSlider(
                items: carouselImages.map((imagePath) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  enableInfiniteScroll: true,
                ),
              ),

              const SizedBox(height: 20),

              sectionTitle('Plant Medicines'),
              horizontalItemList(medicines),

              sectionTitle('Plant Care Tools'),
              horizontalItemList(tools),

              sectionTitle('Agricultural Equipment'),
              horizontalItemList(agriTools),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget horizontalItemList(List<Map<String, String>> items) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        items[index]['image']!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    items[index]['name']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
