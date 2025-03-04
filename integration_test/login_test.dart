import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/common_widgets/common_text_form_field.dart';
import 'package:flutter_starter_kit/common_widgets/counter_stepper.dart';
import 'package:flutter_starter_kit/features/authentication/data/firebase_auth_repository.dart';
import 'package:flutter_starter_kit/features/authentication/domain/auth_status.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/email_verification/email_verification_screen.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/login_screen/login_screen.dart';
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

  testWidgets('Login flow - success case', (WidgetTester tester) async {
    when(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .thenAnswer((_) async {
      return AuthStatus.authenticated;
    });

    await tester.localizedPump(
      const LoginScreen(),
      useRouter: true,
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );

    // Enter email
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .first;
    await tester.enterText(textFieldFinder, 'test@gmail.com');

    // Enter password
    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .last;
    await tester.enterText(passwordTextFieldFinder, 'password123');

    // Tap login button
    final Finder loginButton = find.text('Login');
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .called(1);
    expect(find.byType(CounterStepper), findsOneWidget);
    expect(find.text(tester.t.count_counter(0)), findsOneWidget);
  });

  testWidgets('Login flow - failure case', (WidgetTester tester) async {
    when(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .thenAnswer((_) async {
      return AuthStatus.invalidEmail;
    });

    await tester.localizedPump(
      const LoginScreen(),
      useRouter: true,
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );

    // Enter email
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .first;
    await tester.enterText(textFieldFinder, 'test@gmail.com');

    // Enter password
    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .last;
    await tester.enterText(passwordTextFieldFinder, 'password123');

    // Tap login button
    final Finder loginButton = find.text('Login');
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .called(1);
    expect(find.byType(CounterStepper), findsNothing);
    expect(find.text(tester.t.count_counter(0)), findsNothing);
    expect(find.text(tester.t.auth_unableToLogin), findsOneWidget);
  });

  testWidgets('Login flow - user email unverified case',
      (WidgetTester tester) async {
    when(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .thenAnswer((_) async {
      return AuthStatus.emailNotVerified;
    });

    await tester.localizedPump(
      const LoginScreen(),
      useRouter: true,
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    final Finder textFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .first;
    await tester.enterText(textFieldFinder, 'test@gmail.com');

    final Finder passwordTextFieldFinder = find
        .descendant(
          of: find.byType(CommonTextformField),
          matching: find.byType(TextField),
        )
        .last;
    await tester.enterText(passwordTextFieldFinder, 'password123');

    final Finder loginButton = find.text('Login');
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    verify(() => mockAuthRepository.signInWithEmailPassword(any(), any()))
        .called(1);
    expect(find.byType(EmailVerificationScreen), findsOneWidget);
  });
}
