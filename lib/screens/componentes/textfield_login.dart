import 'package:flutter/material.dart';

class TextFormField_login extends StatelessWidget {
  final controller;
  final String labelText;
  final bool obscureText;
  final String valor;

  const TextFormField_login({
    super.key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12),
        ),
        hintText: labelText,
      ),
      validator: (value) {
        if (value!.isEmpty || value != valor) {
          return 'Please enter a valid ${labelText}';
        }
        return null;
      },
    );
  }
}
