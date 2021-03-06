import 'package:flutter/material.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';

class Observation extends InheritedWidget {
  final String projectID; 
  final Map<int, String> answers;
  final String className; 
  final String teacherID; 
  const Observation({
    Key key,
    this.projectID, this.answers, this.className, this.teacherID, child
    }): super(key: key, child: child); 
  void addAnswer(int questionNum, String value){
    answers[questionNum] = value; 
    //print("Answers: " + answers[questionNum]);
  }

  static Observation of(BuildContext context) => 
    context.inheritFromWidgetOfExactType(Observation); 

  Map<String, dynamic> toJson()=> 
  {
    'projectID': projectID, 
    'answers' : answers
  };

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true; 
  }
}
