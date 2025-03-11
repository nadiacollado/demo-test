import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/widgets.dart' show CommonFullWidth;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: CommonFullWidth,
)
Widget useCaseCommonFullWidth(BuildContext context) {
  return Column(
    spacing: 10,
    children: [
      CommonFullWidth(
        child: Container(
          color: Colors.green,
          child: Text('Inside CommonFullWidth'),
        ),
      ),
      Container(
        color: Colors.blue,
        child: Text('Outside CommonFullWidth'),
      ),
    ],
  );
}
