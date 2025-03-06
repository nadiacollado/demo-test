import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/logger.dart';
import '../../../core/user/data/user_repository.dart';
import '../../../core/user/domain/user.dart';
import '../domain/user_profile_form_state.dart';

part 'user_profile_screen_controller.g.dart';

@riverpod
class UserProfileScreenController extends _$UserProfileScreenController {
  @override
  UserProfileFormState build() => const UserProfileFormState();

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updateAge(String age) {
    state = state.copyWith(age: age);
  }

  void updateLocation(String location) {
    state = state.copyWith(location: location);
  }

  void updatePronouns(String pronouns) {
    state = state.copyWith(pronouns: pronouns);
  }

  Future<bool> saveProfile() async {
    final UserRepository userRepository = ref.read(userRepositoryProvider);
    final Map<String, dynamic> updates = state.getChangedFields();
    if (updates.isEmpty) return false;

    try {
      await userRepository.updateUserProfile(updates);
      logger.info(message: 'Profile updated successfully.');
      return true;
    } catch (e, stackTrace) {
      logger.error(message: 'Error saving profile: $e', stack: stackTrace);
      return false;
    }
  }

  Stream<User?> getUser() {
    final UserRepository userRepository = ref.read(userRepositoryProvider);
    return userRepository.getUserStream();
  }
}
