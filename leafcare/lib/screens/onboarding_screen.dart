import 'package:flutter/material.dart';
import 'package:leafcare/constants/images_path.dart';
import 'package:leafcare/screens/home.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Image.asset(
              ImagesPath.onBoarding,
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: width * 0.08, vertical: height * 0.035),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LeafCare',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Learn how to take care of your plants and keep them healthy',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: height * 0.018),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      },
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
