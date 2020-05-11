import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';

import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';
import 'package:sensational_science/models/classData.dart';



class AddRoster extends StatefulWidget{
  final ClassData classData;
//  final String name;
  AddRoster({this.classData});
  @override
  _AddRosterState createState() => _AddRosterState();
}


class _AddRosterState extends State<AddRoster>{
  String name;
  List<DynamicWidget> roster=[];

  addStudent(){
    roster.add(new DynamicWidget());
    setState((){
    });
  }

 submitData(ClassData classData) async {
  //String val='Success!';
  CollectionReference classRoster = Firestore.instance.collection('Teachers').document(classData.teachID).collection('Classes').document(classData.classID).collection('Roster');
  CollectionReference classProjects = Firestore.instance.collection('Teachers').document(classData.teachID).collection('Classes').document(classData.classID).collection('Projects');
  DocumentReference classInfo = Firestore.instance.collection('Teachers').document(classData.teachID).collection('Classes').document(classData.classID);
  //add students and project codes for existing projects
  roster.forEach((e) async{
    DocumentReference newStudent = await classRoster.add({'name':e.controller.text});
    QuerySnapshot eachProject = await classProjects.getDocuments();
    eachProject.documents.forEach((project) async {
      var codeRef = await classProjects.document(project.documentID).collection('Students').add({
        'student': newStudent.documentID, //student doc id in roster
        'completed': false, //has student submitted data
      });
      await newStudent.setData({
        'codes': FieldValue.arrayUnion([
          {project.documentID: codeRef.documentID}
        ]) //list of codes for each student for all projects, {projectCode : studentCode}
      }, merge: true);
    });
    classInfo.get().then((doc) {
      classInfo.updateData({'students': doc.data['students'] + 1 });
    });
    classData.studentCount++;
  }); 

  //increment the count of students in the class


  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Students added!'),
        content: Text('Students have been added to the class'),
        actions: <Widget>[
          RaisedButton(child: Text("Close"),
            onPressed: () {Navigator.of(context).pop();},
          ),
        ]
      );
    },
  );
  roster = [];
  setState(() {});
}

String success = '';
@override

Widget build(BuildContext context){
  final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("View & Add To Roster"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            new Text('Current Roster'),
            new StreamBuilder(
              stream: Firestore.instance.collection('Teachers').
                document(user.uid)
                .collection('Classes')
                .document(widget.classData.classID)
                .collection('Roster')
                .snapshots(),
              builder: (BuildContext context, snapshot) {
                if(!snapshot.hasData) return new Text('...Loading');
                return new Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: new ListView(
                      children: snapshot.data.documents.map<Widget>((doc){
                        return new ListTile(
                          title: new Text(doc['name']),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            new Divider(
              color: Colors.blue,
              height: 10.0,
            ),
            new Text('Students to add:'),
            new Expanded(
              child: new SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: new ListView.builder(
                  itemCount: roster.length,
                  itemBuilder: (_, index)=>roster[index]
                ),
              ),
            ),
            new Container(
              child: Text(success),
            ),
            new RaisedButton(
              child: new Text('Submit Students'),
              onPressed: ()=> submitData(widget.classData),
            ),
            new RaisedButton(
              child: new Text('Add Another Student'),
              onPressed: addStudent,
            ),
          ],
        ),
      ),
    );
    
  
}
}

class DynamicWidget extends StatelessWidget{
  final controller = new TextEditingController();
  @override
  Widget build(BuildContext context){
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(hintText: 'Enter Student Name'),
      ),
    );
  }
}