import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_test/core/common_widgets/common_text_form_field.dart';
import 'package:demo_test/features/authentication/data/firebase_auth_repository.dart';
import 'package:demo_test/features/authentication/domain/auth_status.dart';
import 'package:demo_test/features/authentication/presentation/email_verification/email_verification_screen.dart';
import 'package:demo_test/features/authentication/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/utils/localized_pump.dart';

// Mock Classes
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  testWidgets('Sign Up flow - success case', (WidgetTester tester) async {
    when(() => mockAuthRepository.createUser(any(), any()))
        .thenAnswer((_) async {
      return AuthStatus.emailNotVerified;
    });

    await tester.localizedPump(
      const SignUpScreen(),
      useRouter: true,
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      initialLocation: '/auth/signUp',
    );

    // Enter email
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextFormField),
          matching: find.byType(TextField),
        )
        .first;
    await tester.enterText(textFieldFinder, 'test@gmail.com');

    // Enter password
    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextFormField),
          matching: find.byType(TextField),
        )
        .at(1);
    await tester.enterText(passwordTextFieldFinder, 'password123');

    // Confirm password
    final Finder confirmPasswordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextFormField),
          matching: find.byType(TextField),
        )
        .at(2);
    await tester.enterText(confirmPasswordTextFieldFinder, 'password123');

    // Tap create account button
    final Finder createAccountButton = find.text(tester.t.auth_createAccount);
    await tester.pumpAndSettle();
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.createUser(any(), any())).called(1);
    expect(find.byType(EmailVerificationScreen), findsOneWidget);
  });

  testWidgets('Sign Up flow - failure case', (WidgetTester tester) async {
    when(() => mockAuthRepository.createUser(any(), any()))
        .thenAnswer((_) async {
      return AuthStatus.invalidEmail;
    });

    await tester.localizedPump(
      const SignUpScreen(),
      useRouter: true,
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
      initialLocation: '/auth/signUp',
    );

    // Enter email
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextFormField),
          matching: find.byType(TextField),
        )
        .at(0);
    await tester.enterText(textFieldFinder, 'gmail.com');

    // Enter password
    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextFormField),
          matching: find.byType(TextField),
        )
        .at(1);
    await tester.enterText(passwordTextFieldFinder, 'password123');

    // Confirm password
    final Finder confirmPasswordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextFormField),
          matching: find.byType(TextField),
        )
        .at(2);
    await tester.enterText(confirmPasswordTextFieldFinder, 'password123');

    // Tap create account button
    final Finder createAccountButton = find.text(tester.t.auth_createAccount);
    await tester.pumpAndSettle();
    await tester.tap(createAccountButton);
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.createUser(any(), any())).called(1);
    expect(find.text(tester.t.auth_unableToCreateAccount), findsOneWidget);
  });
}
