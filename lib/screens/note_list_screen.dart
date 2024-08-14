import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/models/note_fab.dart';
import 'package:notes/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart'; // Add this import
import 'note_detail_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  NoteListScreenState createState() => NoteListScreenState();
}

class NoteListScreenState extends State<NoteListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshNoteList();
  }

  Future<void> _refreshNoteList() async {
    await Provider.of<NoteProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final noteProvider = Provider.of<NoteProvider>(context);
    final noteList = noteProvider.noteList.where((note) {
      final searchQueryLower = _searchQuery.toLowerCase();
      final noteTitleLower = note.title.toLowerCase();
      final noteContentLower = note.content.toLowerCase();
      return noteTitleLower.contains(searchQueryLower) ||
          noteContentLower.contains(searchQueryLower);
    }).toList(); // Reverse the list to show the newest notes on top

    const textStyle1 = TextStyle(
        fontSize: 20, fontWeight: FontWeight.w900, color: Colors.orange);
    final textStyle2 = TextStyle(
      color: theme.textTheme.headlineMedium!.color,
      letterSpacing: theme.textTheme.headlineMedium!.letterSpacing,
      fontSize: theme.textTheme.headlineMedium!.fontSize,
      fontWeight: theme.textTheme.headlineMedium!.fontWeight,
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.primaryColor,
            expandedHeight: 100.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Notes',
                style: TextStyle(
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 18, bottom: 10),
            ),
          ),
          SliverPersistentHeader(
            pinned: false,
            delegate: _SearchBarDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.cardTheme.color,
                  ),
                  child: TextField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: theme.cardColor,
                      prefixIcon:
                          Icon(Icons.search, color: theme.iconTheme.color),
                    ),
                    onChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              childCount: noteList.length,
              itemBuilder: (context, index) {
                final note = noteList[index];
                final dateTime = note.updatedAt.isNotEmpty == true
                    ? note.updatedAt
                    : note.createdAt;
                return OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  openBuilder: (context, _) => NoteDetailScreen(note: note),
                  closedElevation: 0,
                  openColor: theme.primaryColor,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  closedColor: theme.primaryColor,
                  closedBuilder: (context, openContainer) => GestureDetector(
                    onTap: openContainer,
                    child: Card(
                      color: theme.cardTheme.color!,
                      margin: const EdgeInsets.all(4),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              note.title,
                              maxLines: 2,
                              style: textStyle1,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              note.content,
                              maxLines: 8,
                              style: textStyle2,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    dateTime,
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                TextButton(
                                  onPressed: () {
                                    noteProvider.deleteNote(note.id!);
                                  },
                                  child: const Text("Delete",
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (context, _) => const NoteDetailScreen(),
          closedElevation: 0,
          closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
          closedColor: theme.floatingActionButtonTheme.backgroundColor!,
          closedBuilder: (context, openContainer) => FloatingActionButton(
            backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
            onPressed: openContainer,
            child: const AddFab(),
          ),
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
