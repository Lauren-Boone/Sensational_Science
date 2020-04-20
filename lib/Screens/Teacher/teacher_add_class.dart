import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sensational_science/models/user.dart';


class AddClassPage extends StatefulWidget{
  AddClassPage({Key key}) : super(key: key);

  @override
  _AddClassPageState createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _formKey = GlobalKey<FormState>();
  final classNameController = TextEditingController();
  final subjectController = TextEditingController();
  final levelController = TextEditingController();
  final schoolController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final CollectionReference classCollection = Firestore.instance.collection('Teachers').document(user.uid).collection('Classes');
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Class"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: classNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter class name (must be unique)',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please a unique class name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  hintText: 'Class Subject',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a subject';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: levelController,
                decoration: const InputDecoration(
                  hintText: 'class level',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a class level';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: schoolController,
                decoration: const InputDecoration(
                  hintText: 'school',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the school';
                  }

                  return null;
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
      floatingActionButton: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back'),
      ),
    );
  }
}

