import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showCommonDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String primaryButtonText,
  VoidCallback? onDismissal,
  VoidCallback? onPrimaryPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryPressed,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (secondaryButtonText != null)
            TextButton(
              onPressed: () {
                if (onSecondaryPressed != null) {
                  onSecondaryPressed();
                }
                context.pop();
              },
              child: Text(secondaryButtonText),
            ),
          TextButton(
            onPressed: () {
              if (onPrimaryPressed != null) {
                onPrimaryPressed();
              }
              context.pop();
            },
            child: Text(primaryButtonText),
          ),
        ],
      );
    },
  ).then((void val) {
    if (onDismissal != null) {
      onDismissal();
    }
  });
}
