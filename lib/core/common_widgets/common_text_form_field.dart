import 'package:flutter/material.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField({
    super.key,
    required this.onChange,
    required this.inputHint,
    this.labelText,
    this.initialValue,
    this.obscureText = false,
    this.useController = false,
    this.icon,
    this.maxLines,
  });

  final ValueChanged<String> onChange;
  final String inputHint;
  final String? labelText;
  final String? initialValue;
  final bool obscureText;
  final bool useController;
  final IconData? icon;
  final int? maxLines;

  @override
  _CommonTextFormFieldState createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(CommonTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue ?? '';
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
      keyboardType: TextInputType.multiline,
      maxLines: widget.maxLines,
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
