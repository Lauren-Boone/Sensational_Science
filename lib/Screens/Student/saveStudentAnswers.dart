import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Student/student_collect_data.dart';
import 'package:sensational_science/models/user.dart';

//references: https://medium.com/47billion/how-to-use-firebase-with-flutter-e4a47a7470ce
//https://stackoverflow.com/questions/52072948/flutter-get-firebase-database-reference-child-all-data/52073274

// var databaseReference = FirebaseDatabase.instance.reference().child("Teachers").child("WIWJTyjBw9WwfUfNQ69D6ABVOx93")
// .child("Classes").child("AbbiTest").child("Projects").child("MMxdCXvncfz8VFNPlc5q").child("Students"); 

Future<void> saveAnswers(
      String uid, String projectID, Observation input) async {
    return Firestore.instance
        .collection('Teachers')
        .document(uid)
        // .collection('Classes')
        // .document(className)
        .collection('Created Projects')
        .document(projectID)
        // .collection('Students')
        // .document(docID)
        .setData({
          'Answers': input.answers.values.toList()
        }, merge: true);
      }

// void saveAnswers(){
//   databaseReference.child("Answers").set({
//     'example': 'test'
//   });
// }

class saveStudentAnswers extends StatefulWidget{
  final Observation results; 
  saveStudentAnswers({this.results});
  @override
  saveStudentAnswersState createState() => saveStudentAnswersState();
}

class saveStudentAnswersState extends State<saveStudentAnswers>{
  @override

  Widget build(BuildContext context) {
        final user = Provider.of<User>(context);
    
        return Scaffold(
      appBar: AppBar(
        title: Text("Submitted Page"),
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.all(10),
        child: Text('You have submitted your project!')
      ),
    );
  }
}