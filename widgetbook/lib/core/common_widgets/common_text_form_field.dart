import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/widgets.dart' show CommonTextFormField;
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

List<IconData> iconOptions = [
  Icons.home,
  Icons.person,
  Icons.email,
  Icons.password,
  Icons.phone,
  Icons.calendar_month,
  Icons.date_range,
];

@widgetbook.UseCase(
  name: 'default',
  type: CommonTextFormField,
)
Widget useCaseCommonTextFormField(BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 10),
      CommonTextFormField(
        onChange: (_) {},
        inputHint: context.knobs
            .string(label: 'Input hint', initialValue: 'Input hint'),
        labelText: context.knobs.stringOrNull(label: 'Label text'),
        initialValue: context.knobs.stringOrNull(label: 'Initial value'),
        obscureText: context.knobs.boolean(label: 'Obscure text'),
        useController: context.knobs.boolean(label: 'Use controller'),
        icon: context.knobs
            .listOrNull(label: 'Icon', options: [null, ...iconOptions]),
        maxLines: context.knobs.intOrNull.input(label: 'Max lines'),
      ),
    ],
  );
}
