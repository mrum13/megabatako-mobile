import 'package:flutter/material.dart';

class TextFormFieldBordered extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final  String? Function(String?) validator;
  final bool obscureText;

  const TextFormFieldBordered({
    super.key,
    required this.controller,
    required this.hint,
    required this.validator,
    required this.obscureText
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black87),
      decoration: InputDecoration(
        
        fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(4)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.indigo),
            borderRadius: BorderRadius.circular(4)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}
