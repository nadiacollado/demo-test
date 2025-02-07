import 'package:flutter/material.dart';

enum CounterStepperDirection { horizontal, vertical }

class CounterStepper extends StatelessWidget {
  const CounterStepper({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    this.direction = CounterStepperDirection.horizontal,
    this.iconSize = 24.0,
    this.iconColor = Colors.black,
  });

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final CounterStepperDirection direction;
  final double iconSize;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return direction == CounterStepperDirection.horizontal
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildButtons(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildButtons(),
          );
  }

  List<Widget> _buildButtons() {
    final buttons = [
      IconButton(
        icon: Icon(Icons.remove, size: iconSize, color: iconColor),
        onPressed: onDecrement,
      ),
      IconButton(
        icon: Icon(Icons.add, size: iconSize, color: iconColor),
        onPressed: onIncrement,
      ),
    ];

    return direction == CounterStepperDirection.vertical
        ? buttons.reversed.toList()
        : buttons;
  }
}
