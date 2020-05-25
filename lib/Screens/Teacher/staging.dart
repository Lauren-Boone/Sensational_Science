import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/Screens/Teacher/teachermain.dart';
import 'package:sensational_science/Screens/Teacher/testingNEWcreateproj.dart';
import 'package:sensational_science/models/project.dart';
import '../../Services/projectDB.dart';
import 'package:sensational_science/Screens/Login/login_auth.dart';
import 'package:sensational_science/models/user.dart';
import 'dart:async';
import 'create_project.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../Services/projectDB.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class BasicDateField extends StatefulWidget {
  @override
  BasicDateFieldState createState() => BasicDateFieldState();
}

class BasicDateFieldState extends State<BasicDateField> {
  final format = DateFormat("yyyy-MM-dd");
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Text('Basic Date Field (${format.pattern})'),
      DateTimeField(
        format: format,
        decoration: const InputDecoration(
          hintText: 'Project Due Date',
        ),
        onChanged: (dt) => setState(() => date = dt),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      )
    ]);
  }
}

class StagingPage extends StatefulWidget {
  @override
  StagePageState createState() {
    return StagePageState();
  }
}

class StagePageState extends State<StagingPage> {
  String _currentTitle = '';
  String _currentInfo = '';
  bool pub = true;
  String pubpriv = 'Current Setting: Public';
  final _formKey = GlobalKey<FormState>();
  AddProject proj;
  var subjectVal = "Physics";
  List<String> subjects = [
    "Physics",
    "Biology",
    "Chemistry",
    "Astronomy",
    "Geography",
    "Geology"
  ];

/*
 String createProjectDoc(String title, bool public ){
 DocumentReference docRef = Firestore.instance
 .collection('Projects')
 .document();
 docRef
 .setData({
   'title': title,
    'public': public,
    'docID': docRef.documentID,

 });
 return docRef.documentID;
  
}
*/
final TextEditingController projectTitleController =
        new TextEditingController();
    final TextEditingController projectInfo = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final CollectionReference projectCollection =
        Firestore.instance.collection('Projects');
    
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Project Info"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.home, color: Colors.black),
              label: Text('Home', style: TextStyle(color: Colors.black)),
                onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => TeacherHome()),
                  (Route<dynamic> route) => false,
                );
                      
              },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Container(
        margin: EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  controller: projectTitleController,
                  validator: (val) =>
                      val.isEmpty ? 'Enter Project Title' : null,
                  decoration: const InputDecoration(
                    hintText: 'Project Title',
                  ),
                  //onChanged: (val) => setState(() => _currentTitle = val),
                ),
                SizedBox(height: 20),
                TextFormField(
                  //initialValue: _currentInfo,
                  controller: projectInfo,
                  validator: (val) =>
                      val.isEmpty ? 'Enter Project Description' : null,
                  decoration: const InputDecoration(
                    hintText: 'Project Description',
                  ),
                  //onChanged: (value) => setState(() => _currentInfo = value),
                ),
                SizedBox(height: 20),
                Center(
                  widthFactor: 50,
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                       
                        child: Text("Please Select a Subject", style: TextStyle(fontSize: 17))
                        ),
                      SizedBox(height: 20),
                      DropdownButton(
                          value: subjectVal,
                          
                          hint: Text("Please Select A Subject"),
                          items: subjects.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              
                              child: Text(value),
                            );
                          }).toList(),

                          onChanged: (String newValue) {
                            subjectVal = newValue;
                           setState(() {
                              
                            });
                            print(subjectVal);
                          },
                          //onChanged: (value) => setState(() => _currentInfo = value),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  value: pub,
                  title:
                      const Text('Is this a public project? (Default Public)'),
                  onChanged: (value) {
                    setState(() {
                      pub = value;
                      print(pub);
                      if (pub.toString() == 'true') {
                        pubpriv = 'Current Setting: Public';
                      } else {
                        pubpriv = 'Current Setting: Private';
                      }
                    });
                  },
                  subtitle: Text(pubpriv),
                ),
                Card(
                  child: ListTile(
                    title: Text('Continue'),
                    subtitle: Text('Add Questions'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      bool titleExists = false;
                      final existingProjects =
                          await projectCollection.getDocuments();
                      for (var doc in existingProjects.documents) {
                        if (doc.data['title'] ==
                            projectTitleController.text.trim()) {
                          titleExists = true;
                        }
                      }
                      if (titleExists) {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Project Title Exists"),
                                  content: Text(
                                      "A project with the title you entered already exists, please enter a unique project title."),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                      }
                      if (projectInfo.text == " ") {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Project Description Missing"),
                                  content: Text(
                                      "A project must have a description."),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                      }
                      if (subjectVal == " ") {
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Project Subject Missing"),
                                  content:
                                      Text("A project must have a subject."),
                                  actions: <Widget>[
                                    RaisedButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]);
                            });
                      }
                      {
                        _currentTitle = projectTitleController.text.trim();
                        _currentInfo = projectInfo.text.trim();
                      }
                      AddProject proj = new AddProject(title: _currentTitle, public: pub, info: _currentInfo, teacherID: user.uid, subject: subjectVal);
                      //String docID = proj.createProjectDoc(_currentTitle, pub, user.uid);
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddQuestionsToProject(title: _currentTitle, proj: proj, pub: pub, uid: user.uid),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
