// ignore_for_file: prefer_mixin, always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/user/data/user_repository.dart';
import 'package:flutter_starter_kit/core/user/domain/user.dart';
import 'package:flutter_starter_kit/features/profile/domain/user_profile_form_state.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_screen.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../test/utils/localized_pump.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockUserProfileScreenController
    extends AutoDisposeNotifier<UserProfileFormState>
    with Mock
    implements UserProfileScreenController {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockUserProfileScreenController mockController;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockController = MockUserProfileScreenController();
  });

  tearDown(() {
    reset(mockUserRepository);
    reset(mockController);
  });

  testWidgets('Displays loading indicator when fetching user data',
      (WidgetTester tester) async {
    when(() => mockUserRepository.getUserStream())
        .thenAnswer((_) => Stream.value(null));

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Displays user profile form when data loads',
      (WidgetTester tester) async {
    const User testUser = User(email: 'test@example.com', username: 'testUser');

    when(() => mockUserRepository.getUserStream())
        .thenAnswer((_) => Stream.value(testUser));

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.text('testUser'), findsExactly(2));
  });

  testWidgets('Displays error message when user stream fails',
      (WidgetTester tester) async {
    when(() => mockUserRepository.getUserStream())
        .thenAnswer((_) => Stream.error('Error loading user'));

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Error loading user'), findsOneWidget);
  });

  testWidgets('Updates username and calls saveProfile()',
      (WidgetTester tester) async {
    const User testUser = User(email: 'test@example.com', username: 'oldUser');

    when(() => mockUserRepository.updateUserProfile(any()))
        .thenAnswer((_) async {});
    when(() => mockController.getUser())
        .thenAnswer((_) => Stream.value(testUser));
    when(() => mockController.saveProfile()).thenAnswer((_) async => true);

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        userProfileScreenControllerProvider.overrideWith(() => mockController),
      ],
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'newUser');

    final Finder saveButton = find.text('Save');
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    verify(() => mockController.saveProfile()).called(1);
  });

  testWidgets('Displays success dialog on successful save',
      (WidgetTester tester) async {
    const User testUser = User(email: 'test@example.com', username: 'testUser');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream.value(testUser));
    when(() => mockController.saveProfile()).thenAnswer((_) async => true);

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        userProfileScreenControllerProvider.overrideWith(() => mockController),
      ],
    );

    await tester.pumpAndSettle();

    final Finder saveButton = find.text('Save');
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Profile updated successfully'), findsOneWidget);
  });

  testWidgets('Displays error dialog on failed save',
      (WidgetTester tester) async {
    const User testUser = User(email: 'test@example.com', username: 'testUser');

    when(() => mockController.getUser())
        .thenAnswer((_) => Stream.value(testUser));
    when(() => mockController.saveProfile()).thenAnswer((_) async => false);

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
        userProfileScreenControllerProvider.overrideWith(() => mockController),
      ],
    );

    await tester.pumpAndSettle();

    final Finder saveButton = find.text('Save');
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to update profile. Please try again.'),
        findsOneWidget);
  });
}
