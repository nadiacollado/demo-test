import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/core/user/data/user_repository.dart';
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
  });

  tearDown(() {
    container.dispose();
  });

  test('updateUsername() should update state', () {
    controller.updateUsername('newUser123');

    expect(controller.state.username, 'newUser123');
  });

  test('saveProfile() should return false if no changes are made', () async {
    final bool result = await controller.saveProfile();

    expect(result, false);
  });

  test('saveProfile() should call repository and return true on success',
      () async {
    controller.updateUsername('updatedUser');

    when(() => mockUserRepository.updateUserProfile(any()))
        .thenAnswer((_) async {});

    final bool result = await controller.saveProfile();

    expect(result, true);
    verify(
      () => mockUserRepository
          .updateUserProfile(<String, dynamic>{'username': 'updatedUser'}),
    ).called(1);
  });

  test('saveProfile() should return false and log error if repository fails',
      () async {
    controller.updateUsername('updatedUser');

    when(() => mockUserRepository.updateUserProfile(any()))
        .thenThrow(Exception('Failed to update'));

    final bool result = await controller.saveProfile();

    expect(result, false);
    verify(() => mockUserRepository.updateUserProfile(any())).called(1);
  });
}
