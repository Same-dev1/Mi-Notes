import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notes/screens/task_dialog.dart'; // Import the TaskDialog
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _refreshTaskList();
  }

  Future<void> _refreshTaskList() async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  void _showTaskDialog({Task? task}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return TaskDialog(task: task);
      },
    ).then((_) => _refreshTaskList()); // Refresh the list after dialog is closed
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final taskList = taskProvider.tasks
        .where((task) {
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
    })
        .toList()
        .reversed
        .toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                'Tasks',
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
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: theme.cardTheme.color,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: theme.cardColor,
                      prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index < taskList.length) {
                  final task = taskList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Slidable(
                      key: ValueKey(taskList[index].id),
                      direction: Axis.horizontal,
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            icon: Icons.delete,
                            autoClose: true,
                            backgroundColor: Colors.red,
                            borderRadius: BorderRadius.circular(25),
                            onPressed: (context) {
                              taskProvider.deleteTask(task.id!);
                            },
                          )
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          _showTaskDialog(task: taskList[index]);
                        },
                        child: Card(
                          child: ListTile(
                            tileColor: theme.listTileTheme.tileColor,
                            shape: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            title: Text(
                              taskList[index].title,
                              maxLines: 1,
                              style: TextStyle(
                                decoration: taskList[index].isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            ),
                            subtitle: Text(
                              '${task.createdAt}',
                              overflow: TextOverflow.clip,
                              style: theme.textTheme.headlineSmall,
                            ),
                            trailing: Checkbox(
                              value: taskList[index].isCompleted,
                              onChanged: (bool? value) {
                                setState(() {
                                  task.isCompleted = value!;
                                });
                                taskProvider.updateTask(task);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox(height: 60); // Add spacing at the bottom
                }
              },
              childCount: taskList.length + 1, // Add one to the child count for the SizedBox
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () => _showTaskDialog(),
          child: const Icon(
            Icons.add,
            size: 35,
            color: Colors.white,
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
