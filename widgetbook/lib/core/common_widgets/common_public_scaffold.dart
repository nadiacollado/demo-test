import 'package:flutter/widgets.dart';
import 'package:flutter_starter_kit/widgets.dart' show CommonPublicScaffold;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: CommonPublicScaffold,
)
Widget useCaseCommonScaffold(BuildContext context) {
  return CommonPublicScaffold(
    const SizedBox.shrink(),
    title: context.knobs.stringOrNull(label: 'Title'),
  );
}
