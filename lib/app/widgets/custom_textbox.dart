import 'package:flutter/material.dart';

class CustomTextbox extends StatelessWidget {
  const CustomTextbox({
    Key? key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              hintText: label,
              prefixIcon: Icon(prefixIcon)),
        ),
      ),
    );
  }
}
