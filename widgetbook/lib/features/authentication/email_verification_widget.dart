import 'package:flutter/widgets.dart';
import 'package:flutter_starter_kit/widgets.dart' show EmailVerificationWidget;
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
