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
    this.bio,
  });
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? age;
  final String? location;
  final String? pronouns;
  final String? bio;

  @override
  ConsumerState<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends ConsumerState<UserProfileWidget> {
  String getGreeting() {
    if (widget.username != null && widget.username!.isNotEmpty) {
      return '${context.t.profile_hello} ${widget.username}!';
    } else if (widget.email != null && widget.email!.isNotEmpty) {
      return '${context.t.profile_hello} ${widget.email}!';
    }
    return context.t.profile_hello;
  }

  Widget _buildUserDetails() {
    final List<String> details = <String>[
      if (widget.pronouns?.isNotEmpty ?? false) widget.pronouns!,
      if (widget.age?.isNotEmpty ?? false) widget.age!,
      if (widget.location?.isNotEmpty ?? false) widget.location!,
    ];

    return details.isNotEmpty
        ? Text(details.join(', '), style: const TextStyle(fontSize: 16))
        : const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.username == null || widget.username!.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                getGreeting(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          Container(
            width: 120,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          if (widget.username != null && widget.username!.isNotEmpty)
            Text(
              widget.username!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          _buildUserDetails(),
          const SizedBox(height: 12),
          if (widget.bio != null && widget.bio!.isNotEmpty)
            Text(
              widget.bio!,
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.goNamed(AppRoute.editProfile.name),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                context.t.profile_editProfile.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
