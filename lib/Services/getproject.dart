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
  List<dynamic> compAnswers = new List();
}

class GetProject {
  String docID;
  String title;
  String info;
  String subject;
  String teacherID;
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
            if ('$key' == 'teacherID') {
              teacherID = value;
            }
            if('$key'== 'subject'){
            this.subject = value;
          }
          }),
          
          questionSnap.data.forEach((key, value) {
            if ('$key' == 'info') {
                this.info = '$value';
              }
            if ('$key' != 'count' &&
                '$key' != 'public' &&
                '$key' != 'title' &&
                '$key' != 'docID' &&
                '$key' != 'hasImage' &&
                '$key' != 'info' &&
                '$key' != 'teacherID' &&
                '$key' != 'subject') {
              // count = value['Number'];
              //print(value['Type']);
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
              
              //print('adding');
              this.questions.add(question);
              //count--;
            }
          }),
          orderProject(count),
        });
  }

  orderProject(int count) {
    //this.questions.sort((a,b)=> a.number.compareTo(b.number));
    //this.questions.forEach((element) {
    this.questions.sort((a, b) => a.number.compareTo(b.number));
    //});
    //this.questions.sort((a,b)=> a.number.compareTo(b.number));
    //for(int i = 0; i < count; ++i){
    //if(this.questions[i].number != i.toString()){

    // }
    // }
    // printproj();
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

  getQuestions() {}

  // printproj() {
  //   questions.forEach((e) {
  //     print(e.question);
  //     print(e.number);
  //     print(e.type);
  //     print(e.answers);
  //   });
  // }
}

class CompiledProject {
  final GetProject proj;
  
  CompiledProject({this.proj});
  List<Questions> answers = new List();
  bool hasAnswers=false;
  Future getStudentsAnswers(String className, String classProjectID) async {
    //print(proj.toString()); 
    QuerySnapshot snap = await Firestore.instance
        .collection('codes')
        .where('Project', isEqualTo: classProjectID)
        .where('Class', isEqualTo: className)
        .getDocuments();
    int j = 0;
    for (int i = 0; i < snap.documents.length; ++i) {
      //print(snap.documents[i].data.toString()); 
      snap.documents[i].data.forEach((key, value) {
        if ("$key" == "Answers") {
          hasAnswers=true;
          j = 0;
          //print("J = $j"); 
          value.forEach((e) {
            if (j < proj.questions.length) {
              //print("Project Questions J = $j"); 
              this.proj.questions[j].compAnswers.add(e.toString());
              j++;
            }
          });
        }
        
      });
    }
    // proj.questions.forEach((element) {
    //   print(element.compAnswers);
    // });
  }
}
