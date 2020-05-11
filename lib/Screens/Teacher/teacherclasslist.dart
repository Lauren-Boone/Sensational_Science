import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';
import 'package:sensational_science/models/classData.dart';
import 'dart:async';
import 'classInfo.dart';

class ClassListPage extends StatefulWidget{
 @override
  _ClassListState createState() => _ClassListState();
}


class _ClassListState extends State<ClassListPage>{
    
 

  
  @override
  getClassList(String teachID){
  
    return (Firestore.instance.collection('Teachers')
          .document(teachID)
          .collection('Classes')
          .snapshots()
          );
  }

  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes")
      ),
          body: Material(
            child: new StreamBuilder<QuerySnapshot>(
          stream: getClassList(user.uid),
          
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData)return new Text('..Loading');
            return Card(
              child: new ListView(
                children: snapshot.data.documents.map((document){
                  return new ListTile( 
                    title: new Text(document['name']),
                    subtitle: new Text('Click to View Class Info'),
                    trailing: Icon(Icons.arrow_forward_ios), 
                    onTap: () async {
                      ClassData nextClass = new ClassData(classID: document.documentID, teachID: user.uid);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>ClassInfo(classData: nextClass),),
                      );
                    },
                  );
                }).toList(),
              ),
            );
          }
        ),
      ),
    );
    
  }
}

