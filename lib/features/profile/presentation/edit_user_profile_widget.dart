import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common_widgets/common_text_form_field.dart';
import '../../../../l10n/translate.dart';
import '../../navigation/app_router.dart';

class EditUserProfileWidget extends ConsumerStatefulWidget {
  const EditUserProfileWidget({
    super.key,
    required this.onUsernameChanged,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onPronounsChanged,
    required this.onAgeChanged,
    required this.onLocationChanged,
    required this.onSave,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.age,
    this.location,
    this.pronouns,
  });
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final ValueChanged<String> onPronounsChanged;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<String> onLocationChanged;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? location;
  final String? pronouns;
  final VoidCallback onSave;

  @override
  ConsumerState<EditUserProfileWidget> createState() =>
      _EditUserProfileWidgetState();
}

class _EditUserProfileWidgetState extends ConsumerState<EditUserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: <Widget>[
        TextButton(
          onPressed: () => context.goNamed(AppRoute.profile.name),
          child: Text(context.t.profile_go_to_profile),
        ),
        Text(context.t.profile_editUsername.toUpperCase()),
        CommonTextFormField(
          useController: true,
          inputHint: context.t.profile_username,
          onChange: widget.onUsernameChanged,
          initialValue: widget.username,
        ),
        Text(context.t.profile_editFirstName.toUpperCase()),
        CommonTextFormField(
          useController: true,
          inputHint: context.t.profile_firstName,
          onChange: widget.onFirstNameChanged,
          initialValue: widget.firstName,
        ),
        Text(context.t.profile_editLastName.toUpperCase()),
        CommonTextFormField(
          useController: true,
          inputHint: context.t.profile_lastName,
          onChange: widget.onLastNameChanged,
          initialValue: widget.lastName,
        ),
        Text(context.t.profile_editPronouns.toUpperCase()),
        CommonTextFormField(
          useController: true,
          inputHint: context.t.profile_pronouns,
          onChange: widget.onPronounsChanged,
          initialValue: widget.pronouns,
        ),
        Text(context.t.profile_editAge.toUpperCase()),
        CommonTextFormField(
          useController: true,
          inputHint: context.t.profile_age,
          onChange: widget.onAgeChanged,
          initialValue: widget.age,
        ),
        Text(context.t.profile_editLocation.toUpperCase()),
        CommonTextFormField(
          useController: true,
          inputHint: context.t.profile_location,
          onChange: widget.onLocationChanged,
          initialValue: widget.location,
        ),
        TextButton(
          onPressed: widget.onSave,
          child: Text(context.t.profile_save),
        ),
      ],
    );
  }
}
