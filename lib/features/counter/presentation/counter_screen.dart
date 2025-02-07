// lib/presentation/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/counter/presentation/counter_screen_controller.dart';
import '../../../common_widgets/counter_stepper.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterScreenControllerProvider);
    final counterScreenControllerNotifier =
        ref.read(counterScreenControllerProvider.notifier);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          counterState.when(
            data: (counter) => Text('Counter: ${counter.value}',
                style: TextStyle(fontSize: 24)),
            loading: () => CircularProgressIndicator(),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
          CounterStepper(
            iconSize: 32.0,
            direction: CounterStepperDirection.horizontal,
            onIncrement: () => counterScreenControllerNotifier.increment(),
            onDecrement: () => counterScreenControllerNotifier.decrement(),
          ),
        ],
      ),
    );
  }
}
