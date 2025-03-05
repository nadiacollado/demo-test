import 'package:flutter/material.dart';

class CommonTextformField extends StatefulWidget {
  const CommonTextformField({
    super.key,
    required this.onChange,
    required this.inputHint,
    required this.labelText,
    this.obscureText = false,
    this.useController = false,
    this.icon,
  });

  final ValueChanged<String> onChange;
  final String inputHint;
  final String labelText;
  final bool obscureText;
  final bool useController;
  final IconData? icon;

  @override
  _CommonTextformFieldState createState() => _CommonTextformFieldState();
}

class _CommonTextformFieldState extends State<CommonTextformField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.labelText);
  }

  @override
  void didUpdateWidget(CommonTextformField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.labelText != oldWidget.labelText) {
      _controller.text = widget.labelText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.useController ? _controller : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.inputHint,
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        border: const OutlineInputBorder(),
      ),
      obscureText: widget.obscureText,
      onChanged: widget.onChange,
    );
  }
}
