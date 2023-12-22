import 'package:flutter/material.dart';
import 'package:krishanthmart_new/utils/colors.dart';
class CustomGreenButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const CustomGreenButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Define the button style
      style: ElevatedButton.styleFrom(
        primary: MyTheme.accent_color2, // Set the button color to green
        onPrimary: Colors.white, // Set the text color to white
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
      ),
      // Define the onPressed callback
      onPressed: onPressed,
      // Define the button text
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 16.0), // Adjust text size if needed
      ),
    );
  }
}