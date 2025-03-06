import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets/common_text_form_field.dart';
import '../../../../l10n/translate.dart';

class EditUserProfileWidget extends ConsumerStatefulWidget {
  const EditUserProfileWidget({
    super.key,
    required this.onUsernameChanged,
    required this.onFirstNameChanged,
    required this.onLastNameChanged,
    required this.onPronounsChanged,
    required this.onAgeChanged,
    required this.onLocationChanged,
    required this.onBioChanged,
    required this.onSave,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.age,
    this.location,
    this.pronouns,
    this.bio,
  });
  final ValueChanged<String> onUsernameChanged;
  final ValueChanged<String> onFirstNameChanged;
  final ValueChanged<String> onLastNameChanged;
  final ValueChanged<String> onPronounsChanged;
  final ValueChanged<String> onAgeChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onBioChanged;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? location;
  final String? pronouns;
  final String? bio;
  final VoidCallback onSave;

  @override
  ConsumerState<EditUserProfileWidget> createState() =>
      _EditUserProfileWidgetState();
}

class _EditUserProfileWidgetState extends ConsumerState<EditUserProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildField(
            context.t.profile_editUsername,
            context.t.profile_username,
            widget.onUsernameChanged,
            widget.username,
          ),
          _buildField(
            context.t.profile_editFirstName,
            context.t.profile_firstName,
            widget.onFirstNameChanged,
            widget.firstName,
          ),
          _buildField(
            context.t.profile_editLastName,
            context.t.profile_lastName,
            widget.onLastNameChanged,
            widget.lastName,
          ),
          _buildField(
            context.t.profile_editPronouns,
            context.t.profile_pronouns,
            widget.onPronounsChanged,
            widget.pronouns,
          ),
          _buildField(
            context.t.profile_editAge,
            context.t.profile_age,
            widget.onAgeChanged,
            widget.age,
          ),
          _buildField(
            context.t.profile_editLocation,
            context.t.profile_location,
            widget.onLocationChanged,
            widget.location,
          ),
          _buildField(
            context.t.profile_editBio,
            context.t.profile_bio,
            widget.onBioChanged,
            widget.bio,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSave,
              child: Text(context.t.profile_save),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    ValueChanged<String> onChanged,
    String? initialValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        CommonTextFormField(
          useController: true,
          inputHint: hint,
          onChange: onChanged,
          initialValue: initialValue,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
