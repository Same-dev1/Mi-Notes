import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';
import 'screens/task_list_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const NoteListScreen(),
    const TaskListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Theme.of(context).primaryColor, // Set to transparent
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Notes',
            icon: Icon(
              currentIndex == 0 ? Icons.sticky_note_2 : Icons.sticky_note_2_outlined,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Tasks',
            icon: Icon(
              currentIndex == 1 ? Icons.check_box : Icons.check_box_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

