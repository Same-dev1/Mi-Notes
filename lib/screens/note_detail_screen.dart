import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:notes/providers/note_provider.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailScreen({super.key, this.note});

  @override
  NoteDetailScreenState createState() => NoteDetailScreenState();
}

class NoteDetailScreenState extends State<NoteDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  late String _createdAt;
  late String _updatedAt;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
      _createdAt = widget.note!.createdAt;
      _updatedAt = widget.note!.updatedAt;
    } else {
      _title = '';
      _content = '';
      _createdAt = getCurrentDateTime();
      _updatedAt = getCurrentDateTime();
    }
  }

  String getCurrentDateTime() {
    return DateFormat('d MMM  h:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateTextColor = theme.textTheme.headlineMedium!.color;
    final hintTextColor = theme.textTheme.bodySmall!.color;
    Provider.of<NoteProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final noteProvider =
                      Provider.of<NoteProvider>(context, listen: false);
                  if (widget.note == null) {
                    final newNote = Note(
                      title: _title,
                      content: _content,
                      createdAt: _createdAt,
                      updatedAt: getCurrentDateTime(),
                    );
                    await noteProvider.addNote(newNote);
                  } else {
                    final updatedNote = widget.note!.copyWith(
                      title: _title,
                      content: _content,
                      updatedAt: getCurrentDateTime(),
                    );
                    await noteProvider.updateNote(updatedNote);
                  }

                  // Check if the widget is still mounted before using BuildContext
                  if (!mounted) return;

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.done)),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  cursorColor: Colors.orange,
                  inputFormatters: [CapitalizeFirstLetterInputFormatter()],
                  initialValue: _title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: hintTextColor,
                    ),
                    border: InputBorder.none,
                  ),
                  onSaved: (value) => _title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Title cannot be empty' : null,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _updatedAt,
                      style: TextStyle(
                          fontSize: 13,
                          color: dateTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TextFormField(
                    cursorColor: Colors.orange,
                    inputFormatters: [CapitalizeFirstLetterInputFormatter()],
                    initialValue: _content,
                    style: const TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Start typing',
                      hintStyle: TextStyle(
                        color: hintTextColor,
                      ),
                      border: InputBorder.none,
                    ),
                    onSaved: (value) => _content = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Content cannot be empty' : null,
                    maxLines: 30,
                  ),
                ),
              ],
            ),
          ),
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
