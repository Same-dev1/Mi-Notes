import 'package:flutter/material.dart';
import 'package:notes/providers/task_provider.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/note_provider.dart';

class ProviderSetup extends StatelessWidget {
  final Widget child;

  const ProviderSetup({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: child,
    );
  }
}

