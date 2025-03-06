import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/translate.dart';
import '../../navigation/app_router.dart';

class UserProfileWidget extends ConsumerStatefulWidget {
  const UserProfileWidget({
    super.key,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.age,
    this.location,
    this.pronouns,
  });
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? location;
  final String? pronouns;

  @override
  ConsumerState<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends ConsumerState<UserProfileWidget> {
  String getGreeting() {
    return widget.username != null
        ? '${context.t.profile_hello} ${widget.username}!'
        : '${context.t.profile_hello} ${widget.email}!';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: <Widget>[
        Text(getGreeting()),
        if (widget.firstName != null || widget.lastName != null)
          Text('${widget.firstName ?? ''} ${widget.lastName ?? ''}'),
        if (widget.pronouns != null) Text(widget.pronouns!),
        if (widget.age != null) Text(widget.age!),
        if (widget.location != null) Text(widget.location!),
        TextButton(
          onPressed: () => context.goNamed(AppRoute.editProfile.name),
          child: Text(context.t.profile_edit_profile),
        ),
      ],
    );
  }
}
