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
    return DateFormat('EEE, d MMM  h:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final dateTextColor = theme.textTheme.headlineSmall!.color;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: theme.listTileTheme.tileColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.task == null ? 'Create Task' : 'Edit Task'),
          const SizedBox(width: 110),
          Text(
            _createdAt,
            style: TextStyle(
              fontSize: 12,
              color: dateTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              cursorColor: Colors.orange,
              autofocus: true,
              inputFormatters: [CapitalizeFirstLetterInputFormatter()],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.yellow.shade800,
              ),
              initialValue: _title,
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1,
                    color: theme.colorScheme.surface,
                  ),
                ),
                hintText: 'Enter your task here',
                hintStyle: TextStyle(color: dateTextColor, fontSize: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 0.1,
                    color: theme.colorScheme.surface,
                  ),
                ),
              ),
              onSaved: (value) => _title = value!,
              validator: (value) =>
                  value!.isEmpty ? "Can't create an empty task" : null,
            ),
            const SizedBox(height: 10),
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
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: theme.colorScheme.surface,
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
