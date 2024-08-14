import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/note_detail_screen.dart';

class AddFab extends StatefulWidget {
  const AddFab({super.key});

  @override
  AddFabState createState() => AddFabState();
}

class AddFabState extends State<AddFab> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const circleFabBorder = CircleBorder(side: BorderSide.none);

    return OpenContainer(
      transitionDuration: Durations.long4,
      openBuilder: (context, closedContainer) {
        return const NoteDetailScreen();
      },
      openColor: theme.primaryColor,
      onClosed: (success) {},
      closedShape: circleFabBorder,
      closedColor: Colors.orange,
      closedBuilder: (context, openContainer) {
        return Tooltip(
          message: 'Add Note',
          child: InkWell(
            customBorder: circleFabBorder,
            onTap: openContainer,
            child: const SizedBox(
              height: 56,
              width: 56,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
