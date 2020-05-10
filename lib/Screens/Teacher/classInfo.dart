import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Screens/Teacher/classProjects.dart';
import 'dart:async';
import 'roster.dart';
import 'addRoster.dart';
import 'package:sensational_science/models/user.dart';
import 'package:provider/provider.dart';

class ClassInfo extends StatefulWidget {
  //QuerySnapshot snapshot;
 //final String classID;
  final String name;
  final String uid;

  ClassInfo({ this.name,this.uid});

  @override
  _ClassInfoState createState() => _ClassInfoState();
}



class _ClassInfoState extends State<ClassInfo>{
  @override

@override
 


 getInfoList(teachID)  {
    return (Firestore.instance.collection("Teachers")
    .document(teachID)
    .collection('Classes')
    .snapshots()
    );
  
   
   
  }



  @override
   Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Classes")
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Roster"),
                    subtitle: Text("View and add to class roster"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () =>{
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>AddRoster( name: widget.name),
                      ))
                    },
                  ),
                  ListTile(
                    title: Text("Projects"),
                    subtitle: Text("View all projects currently assigned to the class"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () =>{
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>ViewClassProjects( name: widget.name),
                      ))
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
