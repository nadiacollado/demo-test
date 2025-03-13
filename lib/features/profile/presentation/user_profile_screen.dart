import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/common_scaffold.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: UserProfileWidget(
                  email: user?.email,
                  username: user?.username,
                  firstName: user?.firstName,
                  lastName: user?.lastName,
                  age: user?.age,
                  location: user?.location,
                  pronouns: user?.pronouns,
                  bio: user?.bio,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
