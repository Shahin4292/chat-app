import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  final Color? color;
  final Widget? child;

  const CustomButton({
    super.key,
    this.onTap,
    this.text,
    this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.maxFinite, 45),
        backgroundColor: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: child ??
          Text(
            text!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
    );
  }
}