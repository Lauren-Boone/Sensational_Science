import 'package:flutter/material.dart';
import '../Services/projectDB.dart';


class Project{
  final String title;
  final bool public;
  final String docID;
 
  Project({this.title, this.public, this.docID});



}

class ProjectData{

  final String title;
  //final String public;
  //final String docID;
   List<Question> questions;
  ProjectData({this.title});
}