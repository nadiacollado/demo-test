import 'package:flutter/widgets.dart';
import 'package:demo_test/widgets.dart' show EmailVerificationWidget;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'default',
  type: EmailVerificationWidget,
)
Widget useCaseEmailVerificationWidget(BuildContext context) {
  return EmailVerificationWidget(
    onSendEmail: () async {
      await Future.delayed(Duration(seconds: 1));
    },
  );
}
