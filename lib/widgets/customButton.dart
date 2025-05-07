

import 'package:flutter/material.dart';
import 'package:tick/widgets/custom_color';


class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        elevation: 5,
        textStyle: const TextStyle(fontFamily: "Grota", fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      ),
      child: Text(text),
    );
  }
}
