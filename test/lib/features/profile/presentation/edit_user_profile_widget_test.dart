import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/features/profile/presentation/edit_user_profile_widget.dart';
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
  late MockValueChanged mockFirstNameChanged;
  late MockValueChanged mockLastNameChanged;
  late MockValueChanged mockPronounsChanged;
  late MockValueChanged mockAgeChanged;
  late MockValueChanged mockLocationChanged;
  late MockValueChanged mockBioChanged;
  late MockVoidCallback mockSave;

  setUp(() {
    mockUsernameChanged = MockValueChanged();
    mockFirstNameChanged = MockValueChanged();
    mockLastNameChanged = MockValueChanged();
    mockPronounsChanged = MockValueChanged();
    mockAgeChanged = MockValueChanged();
    mockLocationChanged = MockValueChanged();
    mockBioChanged = MockValueChanged();
    mockSave = MockVoidCallback();
  });

  group('EditUserProfileWidget', () {
    const String testUser = 'testuser@example.com';
    const String testUsername = 'Test User';
    Future<Widget> createWidgetUnderTest(WidgetTester tester) async {
      await tester.localizedPump(
        EditUserProfileWidget(
          username: testUsername,
          email: testUser,
          onUsernameChanged: mockUsernameChanged.call,
          onSave: mockSave.call,
          onFirstNameChanged: mockFirstNameChanged.call,
          onLastNameChanged: mockLastNameChanged.call,
          onPronounsChanged: mockPronounsChanged.call,
          onAgeChanged: mockAgeChanged.call,
          onLocationChanged: mockLocationChanged.call,
          onBioChanged: mockBioChanged.call,
        ),
      );

      return tester.firstWidget(find.byType(EditUserProfileWidget));
    }

    testWidgets('calls onUsernameChanged when username is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder usernameField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_username,
      );

      await tester.enterText(usernameField, 'New Username');

      verify(() => mockUsernameChanged('New Username')).called(1);
    });

    testWidgets('calls onFirstNameChanged when first name is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder firstNameField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_firstName,
      );

      await tester.enterText(firstNameField, 'New First Name');

      verify(() => mockFirstNameChanged('New First Name')).called(1);
    });

    testWidgets('calls onLastNameChanged when last name is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder lastNameField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_lastName,
      );

      await tester.enterText(lastNameField, 'New Last Name');

      verify(() => mockLastNameChanged('New Last Name')).called(1);
    });

    testWidgets('calls onPronounsChanged when pronouns are changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder pronounsField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_pronouns,
      );

      await tester.enterText(pronounsField, 'They/Them');

      verify(() => mockPronounsChanged('They/Them')).called(1);
    });

    testWidgets('calls onAgeChanged when age is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder ageField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_age,
      );

      await tester.enterText(ageField, '30');

      verify(() => mockAgeChanged('30')).called(1);
    });

    testWidgets('calls onLocationChanged when location is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder locationField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_location,
      );

      await tester.enterText(locationField, 'New York');

      verify(() => mockLocationChanged('New York')).called(1);
    });
    testWidgets('calls onBioChanged when bio is changed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder bioField = find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextField &&
            widget.decoration?.hintText == tester.t.profile_bio,
      );

      await tester.enterText(bioField, 'New Bio');

      verify(() => mockBioChanged('New Bio')).called(1);
    });

    testWidgets('calls onSave when save button is pressed',
        (WidgetTester tester) async {
      await createWidgetUnderTest(tester);

      final Finder saveButton = find.text(tester.t.profile_save);

      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);

      verify(() => mockSave()).called(1);
    });
  });
}
