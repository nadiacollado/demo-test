// lib/presentation/counter_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/common_scaffold.dart';
import '../../../core/common_widgets/counter_stepper.dart';
import '../../../features/counter/presentation/counter_screen_controller.dart';
import '../../../l10n/translate.dart';
import '../domain/counter.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Counter> counterState =
        ref.watch(counterScreenControllerProvider);
    final CounterScreenController counterScreenControllerNotifier =
        ref.read(counterScreenControllerProvider.notifier);

    return CommonScaffold(
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            counterState.when(
              data: (Counter counter) => Text(
                context.t.count_counter(counter.value),
                style: const TextStyle(fontSize: 24),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (Object error, StackTrace stackTrace) =>
                  Text('Error: $error'),
            ),
            CounterStepper(
              iconSize: 32.0,
              onIncrement: () => counterScreenControllerNotifier.increment(),
              onDecrement: () => counterScreenControllerNotifier.decrement(),
            ),
          ],
        ),
      ),
    );
  }
}
