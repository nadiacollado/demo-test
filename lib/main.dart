import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './common_widgets/common_scaffold.dart';
import './features/counter/presentation/counter_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CommonScaffold(
        title: 'Flutter Counter App',
        body: CounterScreen(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
