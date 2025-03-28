// ignore_for_file: prefer_mixin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo_test/core/user/data/user_repository.dart';
import 'package:demo_test/core/user/domain/user.dart';
import 'package:demo_test/features/profile/domain/user_profile_form_state.dart';
import 'package:demo_test/features/profile/presentation/user_profile_screen.dart';
import 'package:demo_test/features/profile/presentation/user_profile_screen_controller.dart';
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
        .thenAnswer((_) => Stream<User?>.value(null));

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
        .thenAnswer((_) => Stream<User?>.value(testUser));

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('testUser'), findsOneWidget);
  });

  testWidgets('Displays error message when user stream fails',
      (WidgetTester tester) async {
    when(() => mockUserRepository.getUserStream())
        .thenAnswer((_) => Stream<User?>.error(tester.t.profile_error));

    await tester.localizedPump(
      const UserProfileScreen(),
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );

    await tester.pumpAndSettle();

    expect(find.textContaining(tester.t.profile_error), findsOneWidget);
  });
}
