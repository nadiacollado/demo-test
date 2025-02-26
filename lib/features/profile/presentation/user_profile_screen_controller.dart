import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    return const UserProfileFormState();
  }

  Future<void> _loadUserData() async {
    final User? user = await _userRepository.getUser();
    if (user != null) {
      state = state.copyWith(
        originalUser: user,
        email: user.email,
        username: user.username,
      );
    }
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  Future<void> saveProfile() async {
    final Map<String, dynamic> updates = state.getChangedFields();
    if (updates.isNotEmpty) {
      await _userRepository.updateUserProfile(updates);
    }
  }
}
