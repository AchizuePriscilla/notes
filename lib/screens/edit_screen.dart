import 'package:flutter/material.dart';
import 'package:flutterscainitiativeproject/models/note.dart';
import 'package:flutterscainitiativeproject/viewmodels/note_operations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Note currentNote;
  final index;
  EditScreen(this.currentNote, this.index);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  String newNoteTitle;
  String newNoteDescription;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    titleController.text = widget.currentNote.title;
    newNoteTitle = widget.currentNote.title;
    descriptionController.text = widget.currentNote.description;
    newNoteDescription = widget.currentNote.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.now();
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    var date = dateFormat.format(dt).toString();
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  Provider.of<NoteOperations>(context, listen: false)
                      .deleteNote(widget.index);
                  Navigator.pop(context);
                })
          ],
          title: Text(
            'Edit Note',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter title',
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                onChanged: (value) {
                  newNoteTitle = value;
                },
              ),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter note',
                      hintStyle: TextStyle(color: Colors.black)),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    newNoteDescription = value;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  height: 50,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () {
                    Provider.of<NoteOperations>(context, listen: false)
                        .editNote(
                            note: Note(
                                title: newNoteTitle ?? 'Enter title',
                                description: newNoteDescription ?? 'Enter note',
                                dateTime: date),
                            index: widget.index);
                    Navigator.pop(context);
                  },
                  child: Text('Save note',
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
              )
            ],
          ),
        ));
  }
}
