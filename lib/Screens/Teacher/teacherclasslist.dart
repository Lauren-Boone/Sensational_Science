import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassListPage extends StatelessWidget{
  @override
getClassList(String teachName){
 
  return (Firestore.instance.collection('Teachers')
        .document('Dr. Who')
        .collection('Classes')
        .snapshots()
        );
}

  Widget build(BuildContext context){
    return Material(
          child: new StreamBuilder<QuerySnapshot>(
        stream: getClassList("Dr. Who"),
        
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
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

      ),
    );
    
  }
}

