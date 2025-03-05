import 'package:flutter/material.dart';

class CommonFullWidth extends StatelessWidget {
  const CommonFullWidth({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: child,
    );
  }
}
