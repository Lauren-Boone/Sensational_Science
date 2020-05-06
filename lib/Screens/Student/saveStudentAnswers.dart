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
import 'package:sensational_science/models/user.dart';

//references: https://medium.com/47billion/how-to-use-firebase-with-flutter-e4a47a7470ce
//https://stackoverflow.com/questions/52072948/flutter-get-firebase-database-reference-child-all-data/52073274

var databaseReference = FirebaseDatabase.instance.reference().child("Teachers").child("WIWJTyjBw9WwfUfNQ69D6ABVOx93")
.child("Classes").child("AbbiTest").child("Projects").child("MMxdCXvncfz8VFNPlc5q").child("Students"); 
void saveAnswers(){
  databaseReference.child("Answers").set({
    'example': 'test'
  });
}

class saveStudentAnswers extends StatefulWidget{
    saveStudentAnswers({Key key}) : super(key: key);

  @override
  saveStudentAnswersState createState() => saveStudentAnswersState();
}

class saveStudentAnswersState extends State<saveStudentAnswers>{
  @override

  Widget build(BuildContext context){
    return Scaffold(

    );
  }
}