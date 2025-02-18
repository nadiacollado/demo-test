import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonScaffold extends ConsumerWidget {
  const CommonScaffold({
    super.key,
    this.title,
    required this.body,
    this.backgroundColor,
  });

  final String? title;
  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: Text(title ?? 'RetroSpace')),
      body: body,
    );
  }
}
