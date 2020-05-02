import 'package:flutter/material.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';

class Observation {
  var projectID; 
  var answers;
  Observation(String projectID) {
    this.answers = new Map<int, String>(); 
    this.projectID = projectID; 
  }
  void addAnswer(int questionNum, String value){
    answers[questionNum] = value; 
  }

  Map<String, dynamic> toJson()=> 
  {
    'projectID': projectID, 
    'answers' : answers
  };
}
