import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/viewprojectstaging.dart';
import 'package:sensational_science/models/user.dart';
import 'viewproject.dart';
import 'dart:async';



class ListProjects extends StatefulWidget {
  @override
  _ListProjectsState createState() => _ListProjectsState();
}

class _ListProjectsState extends State<ListProjects> {
  String projInfo = 'Need to add project info field to create a project staging page';
  
  getProjectList(String teachID)async{
  
    return (Firestore.instance.collection('Teachers')
          .document(teachID)
          .collection('Created Projects')
          .snapshots()
          );
  }

  
@override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Projects You've Created")
      ),
          body: Material(
            child: new StreamBuilder<QuerySnapshot>(
          stream: (Firestore.instance.collection('Teachers')
          .document(user.uid)
          .collection('Created Projects')
          .snapshots()
          ),
          
          builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData)return new Text('..Loading');
            return Card(
                          child: new ListView(
                children: snapshot.data.documents.map((document){
                  return new ListTile( 
  
                      title: new Text(document['title']),
                      subtitle: new Text('Click to View Project'),
                      trailing: Icon(Icons.arrow_forward_ios), 
                onTap: () =>{
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>ViewProjectStaging(document['title'], document['docIDref'] ),
                    ),
                  )
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

