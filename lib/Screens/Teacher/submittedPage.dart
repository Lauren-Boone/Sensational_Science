import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';

class SubmittedPage extends StatefulWidget {
  final TextEditingController controller;

  SubmittedPage({this.controller});

  @override
  _SubmittedPageState createState() => _SubmittedPageState();
}

class _SubmittedPageState extends State<SubmittedPage> {

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: Text("Submitted Page"),
          actions: <Widget>[
          FlatButton.icon(
             icon: Icon(Icons.home, color: Colors.black),
              label: Text('Home', style: TextStyle(color: Colors.black)),
               onPressed: () {
               Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>TeacherHome()),
             
               );
                      
              },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.all(10),
        child: Text('You have submitted your project!')
      ),
    );
  }
}