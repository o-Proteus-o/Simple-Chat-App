import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.icons,
    this.hintText,
    this.onChanged,
    this.obscure = false,
  });
  Icon icons;
  String? hintText;
  Function(String)? onChanged;
  bool obscure = false;
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
