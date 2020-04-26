import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GetProject{
  final String docID;
  GetProject({this.docID});

getdataFromProject(){
  DocumentReference ref = Firestore.instance
  .collection('Projects')
  .document(docID);
  
  


}

}