// ignore_for_file: prefer_mixin

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_status.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/localized_pump.dart';

class MockEmailVerificationScreenController
    extends AutoDisposeAsyncNotifier<void>
    with Mock
    implements EmailVerificationScreenController {}

void main() {
  late MockEmailVerificationScreenController mockController;

  setUp(() {
    mockController = MockEmailVerificationScreenController();
  });

  testWidgets('EmailVerificationScreen shows success dialog on email sent',
      (WidgetTester tester) async {
    when(() => mockController.sendVerificationEmailAddress()).thenAnswer(
      (_) async => const AsyncValue<AuthStatus>.data(AuthStatus.successful),
    );
    await tester.localizedPump(
      const EmailVerificationScreen(),
      overrides: <Override>[
        emailVerificationScreenControllerProvider.overrideWith(
          () => mockController,
        ),
      ],
    );

    await tester.pumpAndSettle();

    final Finder resendButton = find.text('Resend Email');
    await tester.tap(resendButton);

    await tester.pumpAndSettle();

    expect(find.text('Email Sent'), findsOneWidget);
  });
  testWidgets(
      'EmailVerificationScreen shows Error dialog on failure to send email∂',
      (WidgetTester tester) async {
    when(() => mockController.sendVerificationEmailAddress()).thenAnswer(
      (_) async =>
          const AsyncValue<AuthStatus>.data(AuthStatus.tooManyRequests),
    );
    await tester.localizedPump(
      const EmailVerificationScreen(),
      overrides: <Override>[
        emailVerificationScreenControllerProvider.overrideWith(
          () => mockController,
        ),
      ],
    );

    await tester.pumpAndSettle();

    final Finder resendButton = find.text('Resend Email');
    await tester.tap(resendButton);

    await tester.pumpAndSettle();

    expect(find.text('Please try again Later'), findsOneWidget);
    expect(
      find.text("You've made too many requests in a short period"),
      findsOneWidget,
    );
  });
}
