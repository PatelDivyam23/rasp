import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}