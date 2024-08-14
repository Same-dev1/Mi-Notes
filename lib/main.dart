import 'package:flutter/material.dart';
import 'package:notes/nav_bar.dart';
import 'package:notes/providers/task_provider.dart';
import 'package:notes/theme/theme.dart';
import 'package:provider/provider.dart';
import 'providers/note_provider.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      themeMode: themeProvider.themeMode,
      theme: lightMode,
      darkTheme: darkMode,
      home: const NavBar(),
    );
  }
}
