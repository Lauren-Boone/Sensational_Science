
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Screens/Teacher/create_project.dart';
import '../models/project.dart';

class AddProject{
//final String title;
//final bool public;
//AddProject({this.title, this.public});

/*
    final CollectionReference projCollection = Firestore.instance.collection('Project');
  Future updateprojData(String title, String public) async{
      return await projCollection.document(docID).setData({
        'title': title,
        'public': public,
      });
  }
*/
//get proj list from snapshot
List<Project> _projectListFromSnapshopt(QuerySnapshot snapshot){
  return snapshot.documents.map((doc){
    return Project(
      docID: doc.data['docID'],
      public: doc.data['public'] ?? '',
      title: doc.data['title'] ?? '',
       );
  }).toList();
}

//get proj Stream
/*
Stream<List<Project>> get proj{
  return projCollection.snapshots()
    .map(_projectListFromSnapshopt);
}*/


//get proj doc stream
/*
Stream<ProjectData> get projData{
  return projCollection.document(docID).snapshots()
    .map(_projDataFromSnapshot);
  
}*/

//proj data from snapshot
/*
ProjectData  _projDataFromSnapshot(DocumentSnapshot snapshot){
  return ProjectData(
    title: snapshot.data['title'],
    public: snapshot.data['public'],
  );
}*/

Future<bool> doestitleAlreadyExist(String title) async {
  final QuerySnapshot result = await Firestore.instance
    .collection('Projects')
    .where('title', isEqualTo: title)
    .limit(1)
    .getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  return documents.length == 1;
}



//Create a project Document
String createProjectDoc(String title, bool public ){
 DocumentReference docRef = Firestore.instance
 .collection('Projects')
 .document();
 docRef
 .setData({
   'title': title,
    'public': public,
    'docID': docRef.documentID,

 });
 return docRef.documentID;
  
}

Future<Project> createProjectObj(String title, bool public){

}

  //Add project function
addProjectDataToDoc(List<Widget> acceptData, List<String> acceptType,List<List<TextEditingController>> multAnswers, int numQuestions, String docID)async{
   DocumentReference docRef = Firestore.instance
   .collection('Projects')
   .document(docID);
   for(var i =0; i < numQuestions; ++i){
     
     docRef
     .setData({
       'TESTINGtype': acceptType[i].toString(),
       'TestQUEstion': acceptData[i].toString(), 

     });

 

   }
   
   

}



//get Proj doc stream



}
