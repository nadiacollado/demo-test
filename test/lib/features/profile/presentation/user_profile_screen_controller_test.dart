import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/user/data/user_repository.dart';
import 'package:flutter_starter_kit/core/user/domain/user.dart';
import 'package:flutter_starter_kit/features/profile/domain/user_profile_form_state.dart';
import 'package:flutter_starter_kit/features/profile/presentation/user_profile_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late ProviderContainer container;
  late MockUserRepository mockUserRepository;
  late UserProfileScreenController controller;

  setUp(() {
    mockUserRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: <Override>[
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );
    controller = container.read(userProfileScreenControllerProvider.notifier);

    registerFallbackValue(<String, dynamic>{});
  });

  tearDown(() {
    container.dispose();
  });

  test('Initial state should be empty UserProfileFormState', () {
    expect(controller.state, equals(const UserProfileFormState()));
  });

  test('updateUsername should update state with new username', () {
    const String newUsername = 'testUser';
    controller.updateUsername(newUsername);
    expect(controller.state.username, equals(newUsername));
  });

  test('saveProfile should return true if no fields changed', () async {
    when(() => mockUserRepository.updateUserProfile(any()))
        .thenAnswer((_) async {});

    final bool result = await controller.saveProfile();
    expect(result, isTrue);
    verifyNever(() => mockUserRepository.updateUserProfile(any()));
  });

  test('saveProfile should call updateUserProfile and return true on success',
      () async {
    controller.updateUsername('newUsername');
    when(() => mockUserRepository.updateUserProfile(any()))
        .thenAnswer((_) async {});

    final bool result = await controller.saveProfile();
    expect(result, isTrue);
    verify(() => mockUserRepository.updateUserProfile(any())).called(1);
  });

  test('saveProfile should return false and log error on failure', () async {
    controller.updateUsername('newUsername');
    when(() => mockUserRepository.updateUserProfile(any()))
        .thenThrow(Exception());

    final bool result = await controller.saveProfile();
    expect(result, isFalse);
    verify(() => mockUserRepository.updateUserProfile(any())).called(1);
  });

  test('getUser should return a stream of user data', () async {
    const User user = User(email: 'test@example.com', username: 'testUser');

    when(() => mockUserRepository.getUserStream())
        .thenAnswer((_) => Stream<User?>.value(user));

    final Stream<User?> stream = controller.getUser();

    final User? userSnapshot = await stream.first;

    expect(userSnapshot, equals(user));
    verify(() => mockUserRepository.getUserStream()).called(1);
  });
}
