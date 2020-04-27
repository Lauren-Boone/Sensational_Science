import 'package:flutter/material.dart';



class Project{
  final String title;
  final bool public;
  final String docID;
 
  Project({this.title, this.public, this.docID});
  List<Questions> questions;


}

class Questions{
  final String question;
  final String number;
  final String type;
  Questions({this.question, this.number, this.type});
  
}