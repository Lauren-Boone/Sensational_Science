import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'projectDB.dart';
import '../models/project.dart';

class Questions{
  final String question;
  final String number;
  final String type;
  Questions({this.question, this.number, this.type});
  List<String> answers = new List();
}

class GetProject {
  final String docID;
  final String title;
  GetProject({this.docID, this.title});

  List<Questions> questions = new List();

  final CollectionReference projectCollection =
      Firestore.instance.collection('Projects');

  Stream<GetProject> getdataFromProject() {
    questionData();
  }

  GetProject questionData() {
    //List<String> questiondata;
    int count = 0;
  // int returncount=0;

    Future<DocumentSnapshot> snapshot =
        Firestore.instance.collection('Projects').document(this.docID).get();

    snapshot.then((DocumentSnapshot questionSnap) => {
          questionSnap.data.forEach((key, value) {
            if ('$key' == 'count') {
              count = value;
              count--;
              //returncount=count;
            } else if ('$key' == ('Question' + count.toString())) {
             print(value['Type']);
              Questions question = new Questions(
                
               type: value['Type'],
                number: value['Number'],
                question: value['Question'],
              );
              if (value['Type'] == 'MultipleChoice') {
                value['Answers'].forEach((e){
                  question.answers.add(e.toString());
                });
                //question.answers.addAll(value['Answers']);
              }
              questions.add(question);

              count--;
            }
          }),
        });

       
  }



  printproj() {
    questions.forEach((e) {
      print(e.question);
      print(e.number);
      print(e.type);
      print(e.answers);
    });
  }

}
