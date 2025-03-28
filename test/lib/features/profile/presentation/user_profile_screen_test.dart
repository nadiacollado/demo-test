// ignore_for_file: prefer_mixin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_test/core/user/domain/user.dart';
import 'package:demo_test/features/profile/domain/user_profile_form_state.dart';
import 'package:demo_test/features/profile/presentation/user_profile_screen.dart';
import 'package:demo_test/features/profile/presentation/user_profile_screen_controller.dart';
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
      const UserProfileScreen(),
      overrides: <Override>[
        userProfileScreenControllerProvider.overrideWith(() => mockController),
      ],
    );
    return tester.firstWidget(find.byType(UserProfileScreen));
  }

  testWidgets('Shows loading indicator while fetching user data',
      (WidgetTester tester) async {
    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(null));

    await createWidgetUnderTest(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays error message when fetching user fails',
      (WidgetTester tester) async {
    when(() => mockController.getUser()).thenAnswer(
      (_) => Stream<User?>.error(Exception('Failed to fetch user data')),
    );

    await createWidgetUnderTest(tester);
    await tester.pump();

    expect(find.textContaining('Failed to fetch user data'), findsOneWidget);
  });

  testWidgets('Displays user profile when data is available',
      (WidgetTester tester) async {
    const User user = User(email: 'test@example.com', username: 'test user');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream<User?>.value(user));

    await createWidgetUnderTest(tester);
    await tester.pump();

    expect(find.textContaining('test user'), findsOneWidget);
  });
}
