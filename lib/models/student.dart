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
  String classSubject; 
  DateTime dueDate;

  Student({this.code}) {
    final codeDoc = Firestore.instance.collection('codes').document(code).get();
    codeDoc.then( (doc) {
      print(doc.data['Subject'].toString()); 
      className = doc.data['Class'];
      studentName = doc.data['Name'];
      projectCode = doc.data['Project'];
      projectID = doc.data['ProjectID'];
      studentID = doc.data['Student'];
      teacherID = doc.data['Teacher'];
      projectTitle = doc.data['ProjectTitle'];
      classSubject = doc.data['Subject']; 
      dueDate = doc.data['dueDate'].toDate();
    });
  }

  Student.teacherKey({this.code, this.projectCode, this.projectTitle}) {
    className = "key";
    studentName = "teacher key";
    studentID = code;
    teacherID = code;
  }

}