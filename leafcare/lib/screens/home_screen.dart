import 'package:flutter/material.dart';
import 'package:leafcare/constants/images_path.dart';

import '../components/home_app_bar.dart';
import '../components/text_field_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeAppBar(),

                SizedBox(height: h * .022),

                // Wrap TextFieldWidget with GestureDetector for navigation
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //  MaterialPageRoute(builder: (_) => const SearchPage()),
                    // );
                  },
                  child: AbsorbPointer(
                    child: TextFieldWidget(
                      onChanged: (_) {},
                    ),
                  ),
                ),

                SizedBox(height: h * .022),

                Container(
                  height: h * .25,
                  width: w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImagesPath.exploree),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                SizedBox(height: h * .023),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
