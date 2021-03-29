import 'package:flutter/material.dart';
import 'package:flutterscainitiativeproject/models/note.dart';
import 'package:flutterscainitiativeproject/viewmodels/note_operations.dart';
import 'package:flutterscainitiativeproject/screens/add_screen.dart';
import 'package:flutterscainitiativeproject/screens/edit_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white24,
          title: Text(
            'Notes',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent.shade100..withOpacity(0.8),
          child: Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddScreen(),
                ));
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<NoteOperations>(
              builder: (context, NoteOperations value, child) {
            final notesBox = Hive.box('Notes');

            return notesBox.length == 0
                ? Container(
                    child: Center(
                      child: Text(
                        "Hey there, Click the button to create a note😊",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 11,
                            mainAxisSpacing: 6,
                            childAspectRatio: 3 / 4),
                        itemCount: notesBox.length,
                        itemBuilder: (context, index) {
                          final notes = notesBox.getAt(index) as Note;
                          return Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: NotesCard(
                                note: notes,
                                cardColor: getCardColor(index),
                                date: notes.dateTime,
                                onTap: () {
                                  notesBox.putAt(
                                    index,
                                    Note(
                                        title: notes.title,
                                        description: notes.description,
                                        dateTime: notes.dateTime),
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditScreen(notes, index),
                                      ));
                                },
                              ));
                        },
                      )
                    ],
                  );
          }),
        ));
  }
}

class NotesCard extends StatelessWidget {
  final Note note;
  final Color cardColor;
  final Function onTap;
  final String date;

  NotesCard(
      {@required this.note,
      @required this.cardColor,
      @required this.onTap,
      @required this.date});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(11),
          decoration: BoxDecoration(
              color: cardColor, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                note.description,
                style: TextStyle(fontSize: 17),
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      date != null ? date : "Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

var masterColorList = [
  Color(0xffD0E6FF),
  Color(0xffD0E6FF),
  Color(0xffb06fd6),
  Color(0xffd4d861),
  Color(0xffb06fd6),
  Color(0xffd4d861),
];

Color getCardColor(int index) {
  int cardIndex = index;
  if (index == 0)
    return Color(0xffd4d861);
  else {
    while (cardIndex >= 4) {
      cardIndex = cardIndex - 3;
    }
  }
  return masterColorList[cardIndex];
}
