
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController _textField1Controller = TextEditingController();
  TextEditingController _textField2Controller = TextEditingController();
  TextEditingController _textField3Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Firebase Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textField1Controller,
              decoration: InputDecoration(labelText: 'Field 1'),
            ),
            TextField(
              controller: _textField2Controller,
              decoration: InputDecoration(labelText: 'Field 2'),
            ),
            TextField(
              controller: _textField3Controller,
              decoration: InputDecoration(labelText: 'Field 3'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveDataToFirebase(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveDataToFirebase(BuildContext context) {
    String field1 = _textField1Controller.text;
    String field2 = _textField2Controller.text;
    String field3 = _textField3Controller.text;

    databaseReference.child("data").push().set({
      'field1': field1,
      'field2': field2,
      'field3': field3,
    }).then((_) {
      // Clear the text fields after saving
      _textField1Controller.clear();
      _textField2Controller.clear();
      _textField3Controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data Submitted Successfully')),
      );
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to Submit Data: $onError')),
      );
    });
  }
}