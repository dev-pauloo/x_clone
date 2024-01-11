import 'package:flutter/material.dart';

class DetailsTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
   const DetailsTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
