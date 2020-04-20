import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';

class ClassListPage extends StatelessWidget{
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
    return Material(
        child: new StreamBuilder<QuerySnapshot>(
        stream: getClassList(user.uid),
        
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

