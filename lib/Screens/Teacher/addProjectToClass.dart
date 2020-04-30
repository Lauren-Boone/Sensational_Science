import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';

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

  @override

  Widget build(BuildContext context){
    final user = Provider.of<User>(context);
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Add Project To Class"),
        ),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('Teachers').document(user.uid)
                  .collection('Classes').snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return const Center(
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
                            child: new Text("Class to Assign Project For"),
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
                                    child: new Text(document.data['name']),
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
                  if(!snapshot.hasData) return const Center(
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
                            child: new Text("Project to Assign"),
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
                                    child: new Text(document.documentID),
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
              DateTimeField(
                format: DateFormat("yyyy-MM-dd"),
                decoration: const InputDecoration(
                  hintText: 'Project Due Date',
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      bool docExists = false;
                      final existingClasses = await classCollection.getDocuments();
                      for (var doc in existingClasses.documents) {
                        print(doc.documentID);
                        if (doc.documentID == classNameController.text.trim()) {
                          docExists = true;
                        }
                      }
                      if (docExists) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Class Exists"),
                              content: Text(
                                  "A class with the name you entered already exists, please enter a unique class name."),
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
                      } else {
                        await classCollection.document(classNameController.text.trim()).setData({
                          'name': classNameController.text,
                          'subject': subjectController.text,
                          'level': levelController.text,
                          'school': schoolController.text,
                          'students': 0,
                          'projects': 0,
                        });  
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Success!"),
                              content: Text(
                                  "A new class has been created! Go to View All Classes to see your new class."),
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
                      }
                    } else {
                      return;
                    }
                  },
                  child: Text('Register Class'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
