import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassListPage extends StatelessWidget{
  @override

  Widget build(BuildContext context){
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Teachers').snapshots(),
      builder:(BuildContext conetext, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData)return new Text('..Loading');
        return new ListView(
          children: snapshot.data.documents.map((document){
            return new ListTile( 
              title: new ListTile(
                title: new Text(document['name']),

              ),
            );
            
          }).toList(),
          );
      }

    );
  }
}