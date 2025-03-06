// ignore_for_file: prefer_mixin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/user/domain/user.dart';
import 'package:flutter_starter_kit/features/profile/domain/user_profile_form_state.dart';
import 'package:flutter_starter_kit/features/profile/presentation/edit_user_profile_screen.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../utils/localized_pump.dart';

class MockUserProfileScreenController
    extends AutoDisposeNotifier<UserProfileFormState>
    with Mock
    implements UserProfileScreenController {}

void main() {
  late MockUserProfileScreenController mockController;

  setUp(() {
    mockController = MockUserProfileScreenController();
  });

  Future<Widget> createWidgetUnderTest(WidgetTester tester) async {
    await tester.localizedPump(
      const EditUserProfileScreen(),
      overrides: <Override>[
        userProfileScreenControllerProvider.overrideWith(() => mockController),
      ],
    );

    return tester.firstWidget(find.byType(EditUserProfileScreen));
  }

  testWidgets('Shows loading indicator while fetching user data',
      (WidgetTester tester) async {
    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(null));

    await createWidgetUnderTest(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Calls updateUsername when username field is changed',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', username: 'Old Username');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updateUsername(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder usernameField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_username,
    );

    expect(usernameField, findsOneWidget);

    await tester.enterText(usernameField, 'New Username');

    verify(() => mockController.updateUsername('New Username')).called(1);
  });

  testWidgets('Calls updateFirstName when first name field is changed',
      (WidgetTester tester) async {
    const User user =
        User(email: 'test@example.com', firstName: 'Old First Name');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updateFirstName(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder firstNameField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_firstName,
    );

    expect(firstNameField, findsOneWidget);

    await tester.enterText(firstNameField, 'New First Name');

    verify(() => mockController.updateFirstName('New First Name')).called(1);
  });

  testWidgets('Calls updateLastName when last name field is changed',
      (WidgetTester tester) async {
    const User user =
        User(email: 'test@example.com', lastName: 'Old Last Name');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updateLastName(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder lastNameField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_lastName,
    );

    expect(lastNameField, findsOneWidget);

    await tester.enterText(lastNameField, 'New Last Name');

    verify(() => mockController.updateLastName('New Last Name')).called(1);
  });

  testWidgets('Calls updatePronouns when pronouns field is changed',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', pronouns: 'Old Pronouns');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updatePronouns(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder pronounsField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_pronouns,
    );

    expect(pronounsField, findsOneWidget);

    await tester.enterText(pronounsField, 'New Pronouns');

    verify(() => mockController.updatePronouns('New Pronouns')).called(1);
  });

  testWidgets('Calls updateLocation when location field is changed',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', location: 'Old Location');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updateLocation(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder locationField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_location,
    );

    expect(locationField, findsOneWidget);

    await tester.enterText(locationField, 'New Location');

    verify(() => mockController.updateLocation('New Location')).called(1);
  });

  testWidgets('Calls updateAge when age field is changed',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', age: '25');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updateAge(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder ageField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_age,
    );

    expect(ageField, findsOneWidget);

    await tester.enterText(ageField, '30');

    verify(() => mockController.updateAge('30')).called(1);
  });

  testWidgets('Calls updateBio when bio field is changed',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', bio: 'Old Bio');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.updateBio(any())).thenReturn(null);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder bioField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_bio,
    );

    expect(bioField, findsOneWidget);

    await tester.enterText(bioField, 'New Bio');

    verify(() => mockController.updateBio('New Bio')).called(1);
  });

  testWidgets('Calls saveProfile and shows success dialog when saving succeeds',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', username: 'Test User');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));
    when(() => mockController.saveProfile()).thenAnswer((_) async => true);

    await createWidgetUnderTest(tester);
    await tester.pump();

    final Finder usernameField = find.byWidgetPredicate(
      (Widget widget) =>
          widget is TextField &&
          widget.decoration?.hintText == tester.t.profile_username,
    );

    expect(usernameField, findsOneWidget);

    await tester.enterText(usernameField, 'New Username');
    await tester.pumpAndSettle();

    final Finder saveButton = find.text(tester.t.profile_save);
    await tester.pumpAndSettle();

    await tester.ensureVisible(saveButton);
    expect(saveButton, findsOneWidget);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(
      find.textContaining(tester.t.profile_successMessage),
      findsOneWidget,
    );
  });
}
