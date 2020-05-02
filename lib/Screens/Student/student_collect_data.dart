import 'package:flutter/material.dart';
import 'package:sensational_science/Services/projectDB.dart';
import '../../models/project.dart';
import '../../Services/getproject.dart';

class Observation {
  var projectID; 
  var answers;
  Observation(String projectID) {
    this.answers = new Map<String, String>(); 
    this.projectID = projectID; 
  }
  void addAnswer(String questionID, String value){
    answers.putIfAbsent(questionID, value); 
  }
}
