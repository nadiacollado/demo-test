// lib/presentation/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/counter/presentation/counter_screen_controller.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterScreenControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            counterState.when(
              data: (counter) => Text('Counter: ${counter.value}',
                  style: TextStyle(fontSize: 24)),
              loading: () => CircularProgressIndicator(),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => ref
                      .read(counterScreenControllerProvider.notifier)
                      .decrement(),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => ref
                      .read(counterScreenControllerProvider.notifier)
                      .increment(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
