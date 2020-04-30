import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'projectDB.dart';
import '../models/project.dart';
import '../Screens/Teacher/multiplechoicequestion.dart';
import '../Screens/Teacher/textquestion.dart';

class Questions {
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

  Future<void> get getdataFromProject async {
    return await questionData();
  }

  Future<void> questionData() async {
    //List<String> questiondata;
    int count = 0;
    // int returncount=0;
  //DocumentReference docRef= document[this.docID];
  Future<DocumentSnapshot> snapshot =
        Firestore.instance.collection('Projects').document(this.docID).get();

 // var snapshot = projectCollection.document(this.docID).get();
  //snapshot.asStream();
    return await snapshot.then((DocumentSnapshot questionSnap) => {
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
                value['Answers'].forEach((e) {
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

 int getType(int index) {
    switch (questions[index].type) {
      case 'TextInputItem':
        return 0;
      case 'MultipleChoice':
        return 1;
      case 'ShortAnswerItem':
        return 2;
      case 'UserLocation':
        return 3; 
      case 'AddImageInput':
        return 4; 
      case 'NumericalInputItem':
        return 5; 
    }
    return -1;
  }

  Future<int> printproj() {
    questions.forEach((e) {
      print(e.question);
      print(e.number);
      print(e.type);
      print(e.answers);
    });
  }
}