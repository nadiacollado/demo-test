import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common_widgets/common_button.dart';
import '../../../../l10n/translate.dart';

class EmailVerificationWidget extends ConsumerWidget {
  const EmailVerificationWidget({super.key, required this.onSendEmail});

  final Future<void> Function() onSendEmail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              CommonButton(
                type: ButtonType.transparent,
                text: context.t.auth_resend_email,
                onPressed: () => onSendEmail(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
