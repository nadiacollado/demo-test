# widgetbook

## Launching Widgetbook

To run Widgetbook, follow these steps:

1. Navigate to this Widgetbook directory from the repository root:
```bash
cd widgetbook
```

2. Execute the following command to start Widgetbook:
```bash
flutter run
```

3. Select the device you want to use when prompted.

This command needs to be run from the `widgetbook` directory to ensure that the correct configuration is loaded.

For more information on Widgetbook, please refer to the [Widgetbook documentation](https://docs.widgetbook.io/index).

## Adding Widget UseCases

To add a new Widget UseCase, follow these steps:

1. Export the widget from the `lib/widgets.dart` barrel file.
1. Ensure a directory exists in the `widgetbook/lib` folder that corresponds to the widget use case.
2. Create a file with a name that matches the widget the use case is for.
3. Use the other use cases as examples to follow.

All use cases require a few common lines of code, as shown in the example below:

```dart
import 'package:flutter_starter_kit/widgets.dart' show WidgetName; 
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: WidgetName,
)
Widget useCaseWidgetName(BuildContext context) {
  return WidgetName(
    // Add required parameters here
  );
}
```

## Knobs

Knobs are a way to customize the widget's appearance and behavior. There are many different types of knobs, but some of the most common ones are:

- `bool`: A boolean value.
- `int`: An integer value.
- `double`: A double value.
- `String`: A string value.
- `Color`: A color value.

These serve as a way to adjust the parameters being passed into the widget from within the Widgetbook UI. Most basic knobs do not require being created in a separate file, but more complex knobs can be created separately if the base ones do not suffice.

For more information on creating custom knobs, please refer to the [Widgetbook documentation on Knobs](https://docs.widgetbook.io/knobs).