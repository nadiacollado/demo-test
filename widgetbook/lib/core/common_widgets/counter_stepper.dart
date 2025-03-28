import 'package:flutter/widgets.dart';
import 'package:demo_test/widgets.dart'
    show CounterStepper, CounterStepperDirection;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: CounterStepper,
)
Widget useCaseCounterStepper(BuildContext context) {
  return CounterStepper(
    onIncrement: () {},
    onDecrement: () {},
    direction: context.knobs
        .list(label: 'Direction', options: CounterStepperDirection.values),
    iconSize: context.knobs.double.input(label: 'Icon size'),
  );
}
