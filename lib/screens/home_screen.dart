import 'dart:developer';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
  int initialIndex = 0;
  double aspectRatio() {
    double aspectRatio = getCardHeight(initialIndex);
    log(aspectRatio.toString());
    return aspectRatio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Notes',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
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
                        "Hey there, Click the button to create a note \n😊",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  )
                : StaggeredGridView.countBuilder(
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(1, getCardHeight(index)),
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 11,
                    mainAxisSpacing: 6,
                    itemCount: notesBox.length,
                    itemBuilder: (context, index) {
                      final notes = notesBox.getAt(index) as Note;

                      return NotesCard(
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
                                builder: (context) => EditScreen(notes, index),
                              ));
                        },
                      );
                    },
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
              Column(
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
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  date != null ? date : "Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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

List<double> masterHeightList = [1, 1.3, 1.3, 1];
double getCardHeight(int index) {
  int cardIndex = index;
  if (index == 0)
    return 1;
  else {
    while (cardIndex >= 4) {
      cardIndex = cardIndex - 4;
      log(cardIndex.toString());
    }
  }
  return masterHeightList[cardIndex];
}
