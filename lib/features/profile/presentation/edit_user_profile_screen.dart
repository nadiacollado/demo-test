import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/common_dialog.dart';
import '../../../core/common_widgets/common_scaffold.dart';
import '../../../core/user/domain/user.dart';

import '../../../l10n/translate.dart';
import '../../navigation/app_router.dart';
import 'edit_user_profile_widget.dart';
import 'user_profile_screen_controller.dart';

class EditUserProfileScreen extends ConsumerWidget {
  const EditUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserProfileScreenController controller =
        ref.read(userProfileScreenControllerProvider.notifier);

    return CommonScaffold(
      Center(
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
                padding: const EdgeInsets.all(20),
                child: EditUserProfileWidget(
                  email: user?.email,
                  username: user?.username,
                  firstName: user?.firstName,
                  lastName: user?.lastName,
                  age: user?.age,
                  location: user?.location,
                  pronouns: user?.pronouns,
                  bio: user?.bio,
                  onUsernameChanged: controller.updateUsername,
                  onFirstNameChanged: controller.updateFirstName,
                  onLastNameChanged: controller.updateLastName,
                  onPronounsChanged: controller.updatePronouns,
                  onAgeChanged: controller.updateAge,
                  onLocationChanged: controller.updateLocation,
                  onBioChanged: controller.updateBio,
                  onSave: () async {
                    final bool status = await controller.saveProfile();
                    if (!context.mounted) return;

                    final String title = status
                        ? context.t.profile_success
                        : context.t.profile_error;

                    final String content = status
                        ? context.t.profile_successMessage
                        : context.t.profile_errorMessage;

                    await showCommonDialog(
                      context: context,
                      title: title,
                      content: content,
                      primaryButtonText: context.t.profile_ok,
                    );

                    if (status && context.mounted) {
                      context.goNamed(AppRoute.profile.name);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
