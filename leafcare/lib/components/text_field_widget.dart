import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final Function(String) onChanged;

  const TextFieldWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: h * .06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 2,
          )
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(fontSize: w * .04, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "What is in your mind.?",
          hintStyle: TextStyle(color: Colors.grey, fontSize: w * 0.04),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: Colors.deepOrangeAccent,
            size: w * .07,
          ),
        ),
      ),
    );
  }
}
