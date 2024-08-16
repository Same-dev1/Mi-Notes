import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';
import 'screens/task_list_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void onTabTapped(int index) {
    if (index == currentIndex) return;

    setState(() {
      if (index == 0) {
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
      } else {
        _offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
      }

      currentIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SlideTransition(
            position: _offsetAnimation,
            child: IndexedStack(
              index: currentIndex,
              children: const [
                NoteListScreen(),
                TaskListScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            label: 'Notes',
            icon: Icon(
              currentIndex == 0
                  ? Icons.sticky_note_2
                  : Icons.sticky_note_2_outlined,
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
