import 'package:flutter/widgets.dart';
import 'package:demo_test/widgets.dart' show AuthScaffold;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: AuthScaffold,
)
Widget useCaseCommonScaffold(BuildContext context) {
  return AuthScaffold(
    const SizedBox.shrink(),
    title: context.knobs.stringOrNull(label: 'Title'),
  );
}
