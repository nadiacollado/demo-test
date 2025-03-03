import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/common_widgets/common_button.dart';
import 'package:flutter_starter_kit/common_widgets/common_text_form_field.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/localized_pump.dart';

class MockValueChanged extends Mock {
  void call(String value);
}

class MockVoidCallback extends Mock {
  void call();
}

void main() {
  late MockValueChanged mockUsernameChanged;
  late MockVoidCallback mockSave;

  setUp(() {
    mockUsernameChanged = MockValueChanged();
    mockSave = MockVoidCallback();
  });

  group('UserProfileWidget', () {
    const String testUser = 'testuser@example.com';
    const String testUsername = 'Test User';
    Future<Widget> createWidgetUnderTest(WidgetTester tester) async {
      await tester.localizedPump(
        UserProfileWidget(
          username: testUsername,
          email: testUser,
          onUsernameChanged: mockUsernameChanged.call,
          onSave: mockSave.call,
        ),
      );
      return tester.firstWidget(find.byType(UserProfileWidget));
    }

    testWidgets('renders username and email correctly',
        (WidgetTester tester) async {
      const String testUsername = 'Test User';
      await createWidgetUnderTest(tester);

      expect(find.text('Hello $testUsername!'), findsOneWidget);
    });

    testWidgets('calls onUsernameChanged when username is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.enterText(find.byType(CommonTextformField), 'New Username');
      verify(() => mockUsernameChanged('New Username')).called(1);
    });

    testWidgets('calls onSave when save button is pressed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      await tester.tap(find.byType(CommonButton));
      verify(() => mockSave()).called(1);
    });
  });
}
