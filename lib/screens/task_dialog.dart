import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;

  const TaskDialog({super.key, this.task});

  @override
  TaskDialogState createState() => TaskDialogState();
}

class TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _createdAt;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _createdAt = widget.task!.createdAt ?? getCurrentDateTime();
    } else {
      _title = '';
      _createdAt = getCurrentDateTime();
    }
  }

  String getCurrentDateTime() {
    return DateFormat('EEE, MMM d h:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final dateTextColor = theme.textTheme.headlineSmall!.color;

    return AlertDialog(
      backgroundColor: theme.listTileTheme.tileColor,
      title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              inputFormatters: [CapitalizeFirstLetterInputFormatter()],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.yellow.shade800,
              ),
              initialValue: _title,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                    color: Theme.of(context).textTheme.headlineSmall?.color),
                border: InputBorder.none,
                iconColor: Theme.of(context).textTheme.headlineSmall?.color,
              ),
              onSaved: (value) => _title = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Title cannot be empty' : null,
            ),
            const SizedBox(height: 10),
            Text(
              _createdAt,
              style: TextStyle(
                fontSize: 14,
                color: dateTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Colors.orange,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final taskProvider =
                          Provider.of<TaskProvider>(context, listen: false);
                      if (widget.task == null) {
                        final newTask = Task(
                          title: _title,
                          createdAt: getCurrentDateTime(),
                          isCompleted: false,
                        );
                        await taskProvider.addTask(newTask);
                      } else {
                        final updatedTask = widget.task!.copyWith(
                          title: _title,
                          createdAt: getCurrentDateTime(),
                        );
                        await taskProvider.updateTask(updatedTask);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop(); // Close the dialog
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CapitalizeFirstLetterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newText = newValue.text[0].toUpperCase() + newValue.text.substring(1);
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
