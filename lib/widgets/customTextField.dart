import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const CustomTextfield({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.suffixIcon,
    this.onSuffixTap,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: suffixIcon != null
            ? IconButton(icon: Icon(suffixIcon), onPressed: onSuffixTap)
            : null,
      ),
    );
  }
}
