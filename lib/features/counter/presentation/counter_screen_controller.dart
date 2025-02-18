import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/counter_repository.dart';
import '../domain/counter.dart';

part 'counter_screen_controller.g.dart';

@riverpod
class CounterScreenController extends _$CounterScreenController {
  @override
  FutureOr<Counter> build() {
    final CounterRepository repository = ref.read(counterRepositoryProvider);
    return repository.counter;
  }

  Future<void> increment() async {
    final CounterRepository repository = ref.read(counterRepositoryProvider);

    state = const AsyncLoading<Counter>();

    state = await AsyncValue.guard(() async {
      final Counter updatedCounter = await repository.increment();
      return updatedCounter;
    });
  }

  Future<void> decrement() async {
    final CounterRepository repository = ref.read(counterRepositoryProvider);

    state = const AsyncLoading<Counter>();

    state = await AsyncValue.guard(() async {
      final Counter updatedCounter = await repository.decrement();
      return updatedCounter;
    });
  }
}
