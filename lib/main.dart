import 'package:flutter/material.dart';
import 'package:flutterscainitiativeproject/models/note.dart';
import 'package:flutterscainitiativeproject/viewmodels/note_operations.dart';
import 'package:flutterscainitiativeproject/screens/home_screen.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocDirectory.path);
  Hive.registerAdapter(NoteAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NoteOperations>(
      create: (context) => NoteOperations(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes',
          theme: ThemeData(
            primaryColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
            future: Hive.openBox('Notes'),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError)
                  return Text(snapshot.error.toString());
                else
                  return HomeScreen();
              } else {
                return Scaffold();
              }
            },
          )),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
