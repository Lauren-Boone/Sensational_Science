import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';
import 'package:sensational_science/Services/getproject.dart';

class AddProjectToClass extends StatefulWidget{
  AddProjectToClass({Key key}) : super(key: key);
  @override
  _AddProjectToClassState createState() => _AddProjectToClassState();
}


class _AddProjectToClassState extends State<AddProjectToClass>{
  final _formKey = GlobalKey<FormState>();
  String _class;
  String _project;
  DateTime _date;

  Future<void> assignProject (String uid, String className, String projectID, DateTime dueDate) async {
    //create project under the class
    DocumentReference classDoc = Firestore.instance.collection('Teachers').document(uid).collection('Classes').document(className);
    final projectDoc = await Firestore.instance.collection('Projects').document(projectID).get();
    final projRef = await classDoc.collection('Projects').add({
      'projectID': projectID, //project doc id in top level project collection
      'projectTitle': projectDoc.data['title'], //project title
      'dueDate': dueDate, //due date
    });
    print("added project to class's projects");

    //create a code for each student in the class, create code under the project, store under the student, store all codes
    //under top level codes collection
    final students = await classDoc.collection('Roster').getDocuments();
    for (var student in students.documents) {
      var codeRef = await classDoc.collection('Projects').document(projRef.documentID).collection('Students').add({
        'student': student.documentID, //student doc id in roster
        'completed': false, //has student submitted data
      });
      await classDoc.collection('Roster').document(student.documentID).setData({
        'codes': FieldValue.arrayUnion([codeRef.documentID]) //list of codes for each student for all projects
      }, merge: true);
      await Firestore.instance.collection('codes').document(codeRef.documentID).setData({
        'Teacher': uid, //teacher doc id
        'Class': className, //class doc id
        'Student': student.documentID, //student doc id in roster
        'Name': student.data['name'], //student name in roster
        'Project': projRef.documentID, //project doc id in class
        'ProjectID': projectID, //project doc id in top level project collection
      });
    }
  }

  @override

  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Add Project To Class"),
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Teachers').document(user.uid)
                  .collection('Classes').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Center(
                    child: Text("Loading . . ."),
                  );
                  return new Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    width: MediaQuery.of(context).size.width*0.9,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                            child: Text("Class to Assign Project For"),
                          ),
                        ),
                        new Expanded(
                          flex: 4,
                          child: new InputDecorator(
                            decoration: const InputDecoration(
                              hintText: 'Choose a class',
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            isEmpty: _class == null,
                            child: new DropdownButton(
                              value: _class,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _class = newValue;
                                  print(_class);
                                });
                              },
                              items: snapshot.data.documents.map((DocumentSnapshot document) {
                                return new DropdownMenuItem<String>(
                                  value: document.data['name'],
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: new BorderRadius.circular(3.0),
                                    ),
                                    height: 32.0,
                                    width: MediaQuery.of(context).size.width*0.52,
                                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                                    child: Text(document.data['name']),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              new StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Projects').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Center(
                    child: Text('Loading . . .'),
                  );
                  return new Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    width: MediaQuery.of(context).size.width*0.9,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            padding: EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                            child: Text("Project to Assign"),
                          ),
                        ),
                        new Expanded(
                          flex: 4,
                          child: new InputDecorator(
                            decoration: const InputDecoration(
                              hintText: 'Choose a project',
                              hintStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            isEmpty: _project == null,
                            child: new DropdownButton(
                              value: _project,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _project = newValue;
                                  print(_project);
                                });
                              },
                              items: snapshot.data.documents.map((DocumentSnapshot document) {
                                return new DropdownMenuItem<String>(
                                  value: document.documentID,
                                  child: new Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: new BorderRadius.circular(3.0),
                                    ),
                                    height: 32.0,
                                    width: MediaQuery.of(context).size.width*0.52,
                                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                                    child: Text(document.data['title']),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.1, bottom: 10.0),
                width: MediaQuery.of(context).size.width*0.9,
                child: DateTimeField(
                  format: DateFormat("yyyy-MM-dd"),
                  decoration: const InputDecoration(
                    hintText: 'Project Due Date',
                    hintStyle: TextStyle(color: Colors.green),
                  ),
                  onChanged: (dt) => setState(() => _date = dt),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (_class != null && _project != null && _date != null) {
                      await assignProject(user.uid, _class, _project, _date);
                    } else {
                      return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Missing Data"),
                            content: Text(
                                "You must make a selection for class, project and due date."),
                            actions: <Widget>[
                              RaisedButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Success!"),
                          content: Text(
                              "A project has been added to the class. View the class details to see the assigned project."),
                          actions: <Widget>[
                            RaisedButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ]
                        );
                      }
                    );  
                    Navigator.pop(context);
                    return;       
                  },
                  child: Text('Add Project'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
