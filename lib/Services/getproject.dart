import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'projectDB.dart';


class GetProject{
  final String docID;
  final String title;
  GetProject({this.docID, this.title});
List<Question> questions;

getdataFromProject(){
  DocumentReference docRef = Firestore.instance
  .collection('Projects')
  .document(docID);
  
 Stream<QuerySnapshot> snapshot = Firestore.instance.collection('Projects')
  .where('docID', isEqualTo: this.docID)
  .snapshots();
 
  print(snapshot.where((public) => true));
  


}

}