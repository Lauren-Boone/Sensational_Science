import 'package:flutter/material.dart';
import '../models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'projectDB.dart';
import '../models/project.dart';
import '../Screens/Teacher/multiplechoicequestion.dart';
import '../Screens/Teacher/textquestion.dart';

class Questions {
  final String question;
  final int number;
  final String type;
  Questions({this.question, this.number, this.type});
  List<String> answers = new List();
}

class GetProject {
  String docID;
  String title;
  GetProject(String title, String docID) {
    this.docID = docID;
    this.title = title;
    //squestionData();
  }
  List<Questions> questions = new List();



  Future<void> questionData() async {
 
    int count = 0;
  
    Future<DocumentSnapshot> snapshot =
        Firestore.instance.collection('Projects').document(this.docID).get();

  

    return snapshot.then((DocumentSnapshot questionSnap) => {
          questionSnap.data.forEach((key, value) {
            if ('$key' == 'count') {
              count = value;

              //returncount=count;
            }
          }),
          questionSnap.data.forEach((key, value) {
            if ('$key' != 'count' &&
                '$key' != 'public' &&
                '$key' != 'title' &&
                '$key' != 'docID') {
              // count = value['Number'];
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
              print('adding');
              this.questions.add(question);
              //count--;
            }
          }),
          orderProject(count),
        });
  }

  orderProject(int count) {
    //this.questions.sort((a,b)=> a.number.compareTo(b.number));
    this.questions.forEach((element) {
      this.questions.sort((a, b) => a.number.compareTo(b.number));
    });
    //this.questions.sort((a,b)=> a.number.compareTo(b.number));
    //for(int i = 0; i < count; ++i){
    //if(this.questions[i].number != i.toString()){

    // }
    // }
    printproj();
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

  printproj() {
    questions.forEach((e) {
      print(e.question);
      print(e.number);
      print(e.type);
      print(e.answers);
    });
  }
}
