import 'package:cloud_firestore/cloud_firestore.dart';

class Student{
  final String code;
  String className;
  String studentName;
  String projectCode;
  String projectID;
  String studentID;
  String teacherID;

  Student({this.code}) {
    final codeDoc = Firestore.instance.collection('codes').document(code).get();
    codeDoc.then( (doc) {
      className = doc.data['Class'];
      studentName = doc.data['Name'];
      projectCode = doc.data['Project'];
      projectID = doc.data['ProjectID'];
      studentID = doc.data['Student'];
      teacherID = doc.data['Teacher'];
    });
  }

}