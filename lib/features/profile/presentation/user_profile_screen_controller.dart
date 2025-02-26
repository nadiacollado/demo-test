import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/logger/logger.dart';
import '../../../core/user/data/user_repository.dart';
import '../../../core/user/domain/user.dart';
import '../domain/user_profile_form_state.dart';

part 'user_profile_screen_controller.g.dart';

@riverpod
class UserProfileScreenController extends _$UserProfileScreenController {
  late final UserRepository _userRepository;

  @override
  UserProfileFormState build() {
    _userRepository = ref.read(userRepositoryProvider);
    _loadUserData();
    return const UserProfileFormState(isLoading: true);
  }

  Future<void> _loadUserData() async {
    try {
      final User? user = await _userRepository.getUser();
      if (user != null) {
        logger.info(message: 'User data loaded: ${user.email}');
        state = state.copyWith(
          isLoading: false,
          originalUser: user,
          email: user.email,
          username: user.username,
        );
      } else {
        logger.warn(message: 'User data is null');
        state = state.copyWith(isLoading: false);
      }
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
      );
      logger.error(message: 'Error loading user data $e', stack: stackTrace);
    }
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  Future<void> saveProfile() async {
    final Map<String, dynamic> updates = state.getChangedFields();
    if (updates.isEmpty) return;

    try {
      await _userRepository.updateUserProfile(updates);
      logger.info(message: 'Profile updated successfully.');
    } catch (e, stackTrace) {
      logger.error(message: 'Error saving profile $e', stack: stackTrace);
    }
  }
}
