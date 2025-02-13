import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonScaffold extends ConsumerWidget {
  final String? title;
  final Widget body;
  final Color? backgroundColor;

  const CommonScaffold({
    super.key,
    this.title,
    required this.body,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(title: Text(title ?? 'RetroSpace')),
        body: body);
  }
}
