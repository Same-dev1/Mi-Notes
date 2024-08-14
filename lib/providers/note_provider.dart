import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/database_helper.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _noteList = [];

  List<Note> get noteList => _noteList;

  Future<void> fetchNotes() async {
    _noteList = await NoteDatabaseHelper().getNotes();
    _noteList.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await NoteDatabaseHelper().insertNote(note);
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    await NoteDatabaseHelper().updateNote(note);
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    await NoteDatabaseHelper().deleteNote(id);
    await fetchNotes();
  }
}


