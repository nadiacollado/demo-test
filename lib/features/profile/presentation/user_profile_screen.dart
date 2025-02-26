import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/user_profile_form_state.dart';
import 'user_profile_screen_controller.dart';
import 'user_profile_widget.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfileFormState state =
        ref.watch(userProfileScreenControllerProvider);
    final UserProfileScreenController controller =
        ref.read(userProfileScreenControllerProvider.notifier);

    return Center(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: UserProfileWidget(
            username: state.username,
            onUsernameChanged: controller.updateUsername,
            onSave: controller.saveProfile,
          ),
        ),
      ),
    );
  }
}
