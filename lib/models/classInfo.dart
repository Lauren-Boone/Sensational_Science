import 'package:cloud_firestore/cloud_firestore.dart';

class ClassInfo{
  final String classID;
  final String teachID;
  String className;
  String classLevel;
  int projectCount;
  String school;
  int studentCount;
  String subject;

  ClassInfo({this.classID, this.teachID}) {
    final classDoc = Firestore.instance.collection('Teachers').document(teachID).collection('Classes').document(classID).get();
    classDoc.then( (doc) {
      className = doc.data['name'];
      classLevel = doc.data['level'];
      projectCount = doc.data['projects'];
      school = doc.data['school'];
      studentCount = doc.data['students'];
      subject = doc.data['subject'];
    });
  }

  
}

class ClassSetup{

  final String classID;
 ClassSetup({this.classID});

  String getClassId(){
    return this.classID;
  }
}