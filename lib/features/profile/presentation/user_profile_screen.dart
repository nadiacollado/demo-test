import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/user/domain/user.dart';

import '../../../l10n/translate.dart';
import 'user_profile_screen_controller.dart';
import 'user_profile_widget.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfileScreenController controller =
        ref.read(userProfileScreenControllerProvider.notifier);

    void showStatusDialog({
      required bool success,
    }) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            success ? context.t.profile_success : context.t.profile_error,
          ),
          content: Text(
            success
                ? context.t.profile_successMessage
                : context.t.profile_errorMessage,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t.profile_ok),
            ),
          ],
        ),
      );
    }

    return Center(
      child: StreamBuilder<User?>(
        stream: controller.getUser(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('${context.t.profile_error} ${snapshot.error}');
          }

          final User? user = snapshot.data;

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UserProfileWidget(
                email: user?.email,
                username: user?.username,
                onUsernameChanged: controller.updateUsername,
                onSave: () async {
                  final bool status = await controller.saveProfile();
                  if (!context.mounted) return;
                  showStatusDialog(success: status);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
