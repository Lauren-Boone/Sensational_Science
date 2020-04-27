import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'projectDB.dart';
import '../models/project.dart';


class GetProject{
  final String docID;
  final String title;
  GetProject({this.docID, this.title});
  List<Questions> questions;

  final CollectionReference projectCollection = Firestore.instance.collection('Projects');

getdataFromProject(){
  DocumentReference docRef = Firestore.instance
  .collection('Projects')
  .document(docID);
  

  


}
//get project doc stream
Stream<DocumentSnapshot> get projectData{
  return projectCollection.document(this.docID).snapshots();
}

}