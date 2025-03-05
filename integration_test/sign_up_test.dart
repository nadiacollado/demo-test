import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/common_widgets/common_text_form_field.dart';
import 'package:flutter_starter_kit/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_status.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/sign_up_screen/sign_up_screen.dart';
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
    TestWidgetsFlutterBinding.ensureInitialized();

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
      initialLocation: '/signUp',
    );

    // Enter email
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .at(0);
    await tester.enterText(textFieldFinder, 'test@gmail.com');

    // Enter password
    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .at(1);
    await tester.enterText(passwordTextFieldFinder, 'password123');

    // Confirm password
    final Finder confirmPasswordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
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
      initialLocation: '/signUp',
    );

    // Enter email
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .at(0);
    await tester.enterText(textFieldFinder, 'gmail.com');

    // Enter password
    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .at(1);
    await tester.enterText(passwordTextFieldFinder, 'password123');

    // Confirm password
    final Finder confirmPasswordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
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
