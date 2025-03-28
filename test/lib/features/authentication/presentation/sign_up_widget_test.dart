import 'package:flutter/material.dart';
import 'package:demo_test/core/common_widgets/common_text_form_field.dart';
import 'package:demo_test/features/authentication/presentation/sign_up_screen/sign_up_widget.dart';
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
  late MockCallback mockOnCreateAccount;
  late MockCallback mockOnLogin;
  late void Function(String) mockOnEmailChanged;
  late void Function(String) mockOnPasswordChanged;
  late void Function(String) mockOnConfirmedPasswordChanged;

  setUp(() {
    mockOnCreateAccount = MockCallback();
    mockOnLogin = MockCallback();
    mockOnEmailChanged = MockValueChanged().call;
    mockOnPasswordChanged = MockValueChanged().call;
    mockOnConfirmedPasswordChanged = MockValueChanged().call;
  });

  Future<Widget> createWidgetUnderTest(
    WidgetTester tester, {
    bool isDisabled = false,
  }) async {
    await tester.localizedPump(
      SignUpWidget(
        onCreateAccount: mockOnCreateAccount.call,
        onEmailChanged: mockOnEmailChanged,
        onPasswordChanged: mockOnPasswordChanged,
        onConfirmedPasswordChanged: mockOnConfirmedPasswordChanged,
        onLogin: mockOnLogin.call,
        isCreateAccountDisabled: isDisabled,
      ),
    );
    return tester.firstWidget(find.byType(SignUpWidget));
  }

  group('SignUpWidget', () {
    testWidgets('should display all form fields and buttons',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      expect(
        find.byType(TextFormField),
        findsNWidgets(3),
      );
      expect(find.text(tester.t.auth_createAccount), findsOneWidget);
      expect(find.text(tester.t.auth_haveAccountLogin), findsOneWidget);
    });

    testWidgets('should call onCreateAccount when button is pressed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder buttonFinder = find.text(tester.t.auth_createAccount);
      await tester.tap(buttonFinder);
      await tester.pump();

      verify(() => mockOnCreateAccount.call()).called(1);
    });

    testWidgets(
        'should disable create account button when isCreateAccountDisabled is true',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester, isDisabled: true);

      final FilledButton button =
          tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.enabled, false);
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

    testWidgets(
        'calls onConfirmedPasswordChanged when confirm password input changes',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.enterText(
        find.byType(CommonTextFormField).last,
        'password123',
      );
      verify(() => mockOnConfirmedPasswordChanged('password123')).called(1);
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

      final Finder passwordField = find.byType(TextFormField).at(1);
      await tester.enterText(passwordField, '123');
      await tester.pump();

      expect(
        find.text(tester.t.auth_passwordErrorMessage),
        findsExactly(2),
      );
    });

    testWidgets('should remove error message once a valid email is entered',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalidemail');
      await tester.pump();
      expect(find.text(tester.t.auth_emailErrorMessage), findsOneWidget);

      await tester.enterText(emailField, 'valid@email.com');
      await tester.pump();
      expect(find.text(tester.t.auth_emailErrorMessage), findsNothing);
    });

    testWidgets('should call onLogin when login button is pressed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder loginButtonFinder =
          find.text(tester.t.auth_haveAccountLogin);
      await tester.tap(loginButtonFinder);
      await tester.pump();

      verify(() => mockOnLogin.call()).called(1);
    });
  });
}
