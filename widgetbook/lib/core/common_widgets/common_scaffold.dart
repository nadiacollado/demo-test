import 'package:flutter/widgets.dart';
import 'package:flutter_starter_kit/widgets.dart' show CommonScaffold;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: CommonScaffold,
)
Widget useCaseCommonScaffold(BuildContext context) {
  return CommonScaffold(
    const SizedBox.shrink(),
    title: context.knobs.stringOrNull(label: 'Title'),
  );
}
