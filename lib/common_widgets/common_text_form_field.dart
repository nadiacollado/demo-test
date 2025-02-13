import 'package:flutter/material.dart';

class CommonTextformField extends StatelessWidget {
  final String inputHint;
  final ValueChanged<String> onChange;
  final String labelText;
  final bool obscureText;
  final IconData? icon;

  const CommonTextformField({
    super.key,
    required this.inputHint,
    required this.onChange,
    required this.labelText,
    this.obscureText = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        hintText: inputHint,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
      onChanged: onChange,
    );
  }
}
