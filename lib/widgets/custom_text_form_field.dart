import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.icons,
    this.hintText,
    this.onChanged,
    this.obscure = false,
  });
  final Icon icons;
  final String? hintText;
  final Function(String)? onChanged;
  final bool obscure;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      onChanged: onChanged,
      validator: (data) {
        if (data!.isEmpty) {
          return "Field cannot be empty";
        }
      },
      decoration: InputDecoration(
        label: icons,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
      ),
    );
  }
}
