import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/teacher.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('Teachers');
  Future updateUserData(String name, String email) async{
      return await userCollection.document(uid).setData({
        'name': name,
        'email': email,
      });
  }

//get user list from snapshot
List<Teacher> _teacherListFromSnapshopt(QuerySnapshot snapshot){
  return snapshot.documents.map((doc){
    return Teacher(
      email: doc.data['email'] ?? '',
      name: doc.data['name'] ?? '',
       );
  }).toList();
}

//get User Stream
Stream<List<Teacher>> get user{
  return userCollection.snapshots()
    .map(_teacherListFromSnapshopt);
}


//get user doc stream
Stream<DocumentSnapshot> get userData{
  return userCollection.document(uid).snapshots();
  
}

}