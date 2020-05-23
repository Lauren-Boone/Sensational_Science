import 'package:cloud_firestore/cloud_firestore.dart';

class Student{
  final String code;
  String className;
  String studentName;
  String projectCode;
  String projectID;
  String studentID;
  String teacherID;
  String projectTitle;

  Student({this.code}) {
    final codeDoc = Firestore.instance.collection('codes').document(code).get();
    codeDoc.then( (doc) {
      className = doc.data['Class'];
      studentName = doc.data['Name'];
      projectCode = doc.data['Project'];
      projectID = doc.data['ProjectID'];
      studentID = doc.data['Student'];
      teacherID = doc.data['Teacher'];
      projectTitle = doc.data['ProjectTitle'];
    });
  }

  Student.teacherKey({this.code, this.projectCode, this.projectTitle}) {
    className = "key";
    studentName = "teacher key";
    studentID = code;
    teacherID = code;
  }

}