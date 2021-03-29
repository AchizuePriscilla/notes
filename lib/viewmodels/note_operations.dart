import 'package:flutter/cupertino.dart';
import 'package:flutterscainitiativeproject/models/note.dart';
import 'package:hive/hive.dart';

class NoteOperations extends ChangeNotifier {
  List<Note> _notes = List<Note>();

  List<Note> get getNotes {
    return _notes;
  }

  Note editedNote;

  void addNewNote({String title, String description, String dateTime}) async {
    Note note =
        Note(title: title, description: description, dateTime: dateTime);
    _notes.add(note);
    final notesBox = Hive.box('Notes');
    await notesBox.add(note);

    notifyListeners();
  }

  void editNote({index, Note note}) async {
    _notes.add(note);
    final notesBox = Hive.box('Notes');
    await notesBox.putAt(index, note);

    note = notesBox.getAt(index);

    notifyListeners();
  }

  void deleteNote(int index) async {
    final notesBox = Hive.box('Notes');
    await notesBox.deleteAt(index);

    notifyListeners();
  }

  void setEditedNote(int key) {
    final notesBox = Hive.box('Notes');
    editedNote = notesBox.get(key);
    notifyListeners();
  }

  Note getEditedNote() {
    return editedNote;
  }

  NoteOperations();
}
