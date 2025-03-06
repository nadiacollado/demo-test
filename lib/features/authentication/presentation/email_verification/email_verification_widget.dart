import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/translate.dart';
import '../../application/auth_state_notifier.dart';

class EmailVerificationWidget extends ConsumerWidget {
  const EmailVerificationWidget({super.key, required this.onSendEmail});

  final Future<void> Function() onSendEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthStateNotifier notifier =
        ref.watch(authStateNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 5,
        children: <Widget>[
          const Icon(
            Icons.email,
            size: 75,
            color: Colors.blue,
          ),
          Text(
            context.t.auth_please_verify_email,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                context.t.global_having_trouble,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              TextButton(
                onPressed: () => onSendEmail(),
                child: Text(context.t.auth_resend_email),
              ),
            ],
          ),
          TextButton(
            child: const Text('Sign Out'),
            onPressed: () => notifier.signOut(),
          ),
        ],
      ),
    );
  }
}
