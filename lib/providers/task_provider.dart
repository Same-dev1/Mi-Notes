import 'package:flutter/material.dart';

import '../models/task.dart';
import 'database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    _tasks = await TaskDatabaseHelper().getTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await TaskDatabaseHelper().insertTask(task);
    await fetchTasks(); // Refresh the list
  }

  Future<void> updateTask(Task task) async {
    await TaskDatabaseHelper().updateTask(task);
    await fetchTasks(); // Refresh the list
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabaseHelper().deleteTask(id);
    await fetchTasks(); // Refresh the list
  }
}