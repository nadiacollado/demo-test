import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/localized_pump.dart';

class MockOnSendEmail extends Mock {
  Future<void> call();
}

void main() {
  Future<Widget> createWidget(
    WidgetTester tester, {
    Future<void> Function()? onSendEmail,
  }) async {
    await tester.localizedPump(
      EmailVerificationWidget(
        onSendEmail: onSendEmail ?? () async {},
      ),
    );
    return tester.firstWidget(find.byType(EmailVerificationWidget));
  }

  testWidgets('renders EmailVerificationWidget', (WidgetTester tester) async {
    const String expectedText =
        'Please verify your email address. A confirmation link has been sent to your email.';
    const String expectedButtonText = 'Resend Email';
    final Finder iconFinder = find.byType(Icon);

    await createWidget(tester);

    expect(iconFinder, findsOneWidget);
    expect(find.text(expectedText), findsOneWidget);
    expect(find.text(expectedButtonText), findsOneWidget);
  });
  testWidgets('onSendEmail is called when pressed',
      (WidgetTester tester) async {
    final MockOnSendEmail mockOnSendEmail = MockOnSendEmail();
    when(() => mockOnSendEmail()).thenAnswer((_) async => Future<void>.value());

    await createWidget(tester, onSendEmail: mockOnSendEmail.call);

    await tester.tap(find.text('Resend Email'));
    await tester.pump();

    verify(() => mockOnSendEmail()).called(1);
  });
}
