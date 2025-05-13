import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final w=MediaQuery.of(context).size.width;
    return Row(
      children: [
        Text('Let\'s treat the\nunhealthy plants today!',style: TextStyle(
          color: Colors.green,
          fontWeight:FontWeight.bold,
          fontSize:w*.07,
          height:1
        ),),
        const Spacer(),
      ]
    );
  }
}
