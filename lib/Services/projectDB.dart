import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sensational_science/models/project.dart';

class Question {
  final String type;
  final String question;
  final int number;
  Question({this.type, this.question, this.number});
  Map<String, dynamic> questionMap = Map();
  List<String> answers= new List();
 

  Map toJson() {
    questionMap = Map();
    questionMap['Number'] = this.number;
    questionMap['Type'] = this.type;
    questionMap['Question'] = this.question;

 
    return questionMap;
  }

  Map toJsonMult(List<TextEditingController> answers) {
    int count = 0;
    questionMap = {
      'Answers': answers.toList(),
      'Number': this.number,
      'Question': this.question,
      'Type': this.type,
    };
   

    return questionMap;
  }
}

class AddProject {
  final String title;
  final bool public;
  final String info;
  final String subject;
  AddProject({this.title, this.public, this.info, this.subject});
  List<Question> questions = new List();
  String docID;
  int numberQuestions;


  String getDocID() {
    return docID;
  }
//get proj list from snapshot

  Future<bool> doestitleAlreadyExist(String title) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('Projects')
        .where('title', isEqualTo: title)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }

//adds map to database using key value pairs
  addtodb(int count) async {
    String questionNum = "Question";
    DocumentReference docRef =
        Firestore.instance.collection('Projects').document(docID);
docRef.setData({
  'count': numberQuestions,
},merge: true);
    for (var i = 0; i < count; i++) {
     questionNum = "Question" + questions[i].number.toString();
      questions[i].questionMap.forEach((key, value) {
        if (key == 'Answers') {
          value.forEach((e) {
            docRef.setData({
              questionNum: {
                '$key': FieldValue.arrayUnion([e.text]),
              }
            }, merge: true);
          });
        }
          
        else if(value == this.questions[i].number){
          docRef.setData({
            questionNum: {
             'Number': value,
            }
          }, merge: true);
        }        
        else {
          if(key == 'Type' && value == 'AddImageInput' ){
            docRef.setData({
             
              'hasImage': true,
            
          }, merge: true);
          }

          docRef.setData({
            questionNum: {
              '$key': '$value',
            }
          }, merge: true);
        }
      });
    }
  }

//Addds the data to the project calls variables
  addProjectDataToDoc(
      String uid,
      List<TextEditingController> acceptData,
      List<String> acceptType,
      List<List<TextEditingController>> multAnswers,
      int numQuestions,
      String docID) async {
    List<String> textAnswers;
  numberQuestions= numQuestions;
    var answerCount = 0;
    for (var i = 0; i < numQuestions; i++) {
      this.questions.add(new Question(
          number: i,
          type: acceptType[i].toString(),
          question: acceptData[i].text));
      if (acceptType[i] == 'MultipleChoice') {
        print(multAnswers[answerCount]);
        questions[i].toJsonMult(multAnswers[answerCount]);
        answerCount++;
        //this.questions.add(question);
      } else {
        Map mq = questions[i].toJson();
        //this.questions.add(question);
      }
    }
  }

  String createProjectDoc(String title, bool public, String uid) {
    DocumentReference docRef =
        Firestore.instance.collection('Projects').document();
    docRef.setData({
      'title': title,
      'public': public,
      'docID': docRef.documentID,
      'info': this.info,
      'subject': this.subject,
    });

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
          Firestore.instance
              .collection("Teachers")
              .document(uid)
              .collection('Created Projects')
              .document(),
          {
            'docIDref': docRef.documentID,
            'title': title,
            'info': this.info,
            'subject': this.subject,
          });
    });
    docID = docRef.documentID;
    return getDocID();
  }
}


