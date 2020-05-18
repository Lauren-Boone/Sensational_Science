import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sensational_science/Screens/Teacher/classProjects.dart';
import 'package:sensational_science/Screens/Teacher/addProjectToClass.dart';
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
        title: Text(widget.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
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
                    subtitle: Text("View students, codes, and add to class roster"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () =>{
                      Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => new AddRoster( name: widget.name),
                      ))
                    },
                  ),
                  ListTile(
                    title: Text("Projects"),
                    subtitle: Text("View all projects currently assigned to the class"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () =>{
                      Navigator.of(context).push( new MaterialPageRoute(
                        builder: (context) => new ViewClassProjects( name: widget.name),
                      ))
                    },
                  ),
                  ListTile(
                    title: Text("Add Project"),
                    subtitle: Text("Add a new project to class"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () =>{
                      Navigator.push(context, new MaterialPageRoute(
                        builder: (context) => new AddProjectToClass(),
                      ))
                    },
                  ),
                ],
              ),
            ),
            new Divider(
              color: Colors.blue,
              height: 10.0,
            ),
            Text("Class Information",
              style: TextStyle(fontWeight: FontWeight.bold,),
            ),
            FutureBuilder(
              future: Firestore.instance.collection('Teachers').document(user.uid).collection("Classes").document(widget.name).get(),
              builder: (context, document) {
                if (!document.hasData) {return Text("...Loading");}
                List<String> fields = ['school', 'subject', 'level', 'students', 'projects'];
                List<String> headings = ['', '', 'Class Level: ', 'Count of Student Roster: ', 'Count of Class Projects: '];
                List<ListTile> tiles = [];
                for(var index=0; index<fields.length; index++) {
                  tiles.add(ListTile(
                    title: Text( headings[index] + document.data[fields[index]].toString()),
                  ));
                }
                return Expanded(
                  child: ListView(
                    children: tiles,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
