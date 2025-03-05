import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common_widgets/common_text_form_field.dart';
import '../../../../l10n/translate.dart';

class UserProfileWidget extends ConsumerStatefulWidget {
  const UserProfileWidget({
    super.key,
    required this.onUsernameChanged,
    required this.onSave,
    this.username,
    this.email,
  });
  final ValueChanged<String> onUsernameChanged;
  final String? username;
  final String? email;
  final VoidCallback onSave;

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
        Text(context.t.profile_editUsername.toUpperCase()),
        CommonTextFormField(
          useController: true,
          labelText: widget.username ?? '',
          inputHint: context.t.profile_username,
          onChange: widget.onUsernameChanged,
        ),
        TextButton(
          onPressed: widget.onSave,
          child: Text(context.t.profile_save),
        ),
      ],
    );
  }
}
