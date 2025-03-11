import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/core/common_widgets/common_text_form_field.dart';
import 'package:flutter_starter_kit/features/authentication/presentation/login_screen/login_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/localized_pump.dart';

class MockCallback extends Mock {
  void call();
}

class MockValueChanged extends Mock {
  void call(String value);
}

void main() {
  late MockCallback mockOnLogin;
  late MockCallback mockOnCreateAccount;
  late MockCallback mockOnForgotPassword;
  late void Function(String) mockOnEmailChanged;
  late void Function(String) mockOnPasswordChanged;

  setUp(() {
    mockOnLogin = MockCallback();
    mockOnCreateAccount = MockCallback();
    mockOnForgotPassword = MockCallback();
    mockOnEmailChanged = MockValueChanged().call;
    mockOnPasswordChanged = MockValueChanged().call;
  });

  Future<Widget> createWidgetUnderTest(
    WidgetTester tester, {
    bool isDisabled = false,
  }) async {
    await tester.localizedPump(
      LoginWidget(
        onEmailChanged: mockOnEmailChanged,
        onPasswordChanged: mockOnPasswordChanged,
        onLogin: mockOnLogin.call,
        onCreateAccount: mockOnCreateAccount.call,
        onForgotPassword: mockOnForgotPassword.call,
        isLoginDisabled: isDisabled,
      ),
    );
    return tester.firstWidget(find.byType(LoginWidget));
  }

  group('LoginWidget', () {
    testWidgets('renders all input fields and buttons',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      expect(
        find.byType(CommonTextFormField),
        findsNWidgets(2),
      );
      expect(find.text(tester.t.auth_login), findsOneWidget);
      expect(find.text(tester.t.auth_forgotPassword), findsOneWidget);
      expect(find.text(tester.t.auth_createAnAccount), findsOneWidget);
    });

    testWidgets('calls onEmailChanged when email input changes',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.enterText(
        find.byType(CommonTextFormField).first,
        'test@example.com',
      );
      verify(() => mockOnEmailChanged('test@example.com')).called(1);
    });

    testWidgets('calls onPasswordChanged when password input changes',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.enterText(
        find.byType(CommonTextFormField).last,
        'password123',
      );
      verify(() => mockOnPasswordChanged('password123')).called(1);
    });

    testWidgets('calls onLogin when login button is pressed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.tap(find.text(tester.t.auth_login));
      await tester.pump();
      verify(() => mockOnLogin()).called(1);
    });

    testWidgets('login button is disabled when isLoginDisabled is true',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester, isDisabled: true);

      final FilledButton button =
          tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.enabled, false);
    });

    testWidgets('calls onForgotPassword when forgot password button is tapped',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.tap(find.text(tester.t.auth_forgotPassword));
      await tester.pump();
      verify(() => mockOnForgotPassword()).called(1);
    });

    testWidgets('calls onCreateAccount when create account button is tapped',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.tap(find.text(tester.t.auth_createAnAccount));
      await tester.pump();
      verify(() => mockOnCreateAccount()).called(1);
    });

    testWidgets('should validate email field properly',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalidemail');
      await tester.pump();

      expect(find.text(tester.t.auth_emailErrorMessage), findsOneWidget);
    });

    testWidgets('should validate password field properly',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '123');
      await tester.pump();

      expect(
        find.text(tester.t.auth_passwordErrorMessage),
        findsOneWidget,
      );
    });
  });
}
