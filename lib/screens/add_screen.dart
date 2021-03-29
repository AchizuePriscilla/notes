import 'package:flutter/material.dart';

import 'package:flutterscainitiativeproject/viewmodels/note_operations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    String noteTitle;
    String noteText;
    DateTime dt = DateTime.now();
    var dateFormat = DateFormat("dd-MM-yyyy");
    var date = dateFormat.format(dt).toString();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'New note',
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
                  noteTitle = value;
                },
              ),
              Expanded(
                child: TextField(
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
                    noteText = value;
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
                        .addNewNote(
                            title: noteTitle,
                            description: noteText,
                            dateTime: date);
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
